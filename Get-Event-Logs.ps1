
<#

 .VERSION 
     3 - 4/1/2020

 .AUTHOR  
     Ed Arias 
          
 .EMAIL 
     ed.arias.dev@gmail.com

 .SYNOPSIS 
     Queries listed or inputed servers and checks for specified Logs based on days and log type; outputs via the $Dest variable.
  
 .DESCRIPTION 
     Load serverNames into a text file; alter this command under the $Computers variable, then run. Logs made.
     
 .PARAMETERS
     $Servers: Server(s) to query; Can be local or remote.  Remote needs to be separated by a comma " , "

     $Dest: Change this to where you want the Logs exported

     $LogType: List Log type needed

     $LogCount: Number of entries to go back

 #>

$Servers = Read-Host "What Server Do You Want Logs From?; type localhost or for local only"

# If you want to refer to a list of servers (comment above [Add the '#'] and uncomment [Remove the '#'] below):

# $Servers = Get-Content "c:\Path\To\Your\Server\List.txt"

#######################################################################################################################################################

                                                            #Beware when modifying below#

#######################################################################################################################################################

IF ( -not ([Security.Principal.WindowsPrincipal] `
           [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole( `
           [Security.Principal.WindowsBuiltInRole] "Administrator") ){

        CLS
        Write-Host ""
        Write-Error "Must have administrator privileges to run this script."
        Write-Host ""
        break

                                                                      }

    $LogType = Read-Host "What Log Type? Ex: Application, System, Security, or All"

    $LogCount = Read-Host "Enter number to output 10, 20, 30, 1000 etc..."

    $Dest = "c:\Temp\Logs"

    #$TestPath = Test-Path "c:\Temp\Logs"

IF((Test-Path "c:\Temp\Logs") -match "False" -or "$null"){

    #Create c:\Temp if not found

    New-Item -Path "c:\Temp" -Name "Logs" -ItemType Directory |out-null

                                        }

    IF($Servers -match "localhost|local|LOCALHOST|LOCAL"){

        #Runs on local server/Workstation
    
        ForEach ($_ in $Servers) {

            IF($LogType -match "Application|app|application"){

        Write-Host "Exporting $LogType Logs from $Server to $Dest" -ForegroundColor Yellow

        Get-Eventlog -LogName Application -Newest $LogCount `
        |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv `
        "c:\Temp\Logs\$ENV:COMPUTERNAME.Application.EventLog.csv"

                                             }

            IF($LogType -match "System|sys|SYSTEM"){

        Write-Host "Exporting $LogType Logs from $Server to $Dest" -ForegroundColor Yellow

        Get-Eventlog -LogName System -Newest $LogCount `
        |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv `
        "c:\Temp\Logs\$ENV:COMPUTERNAME.System.EventLog.csv"

                                        }

            IF($LogType -match "Security|sec|security"){

        Write-Host "Exporting $LogType Logs from $Server to $Dest" -ForegroundColor Yellow

        Get-Eventlog -LogName Security -Newest $LogCount `
        |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv `
        "c:\Temp\Logs\$ENV:COMPUTERNAME.Security.EventLog.csv"


                                          }

            IF($LogType -match "All|all|ALL"){

            Write-Host "Exporting $LogType Logs from $Server to $Dest" -ForegroundColor Yellow

            Get-Eventlog -LogName Security -Newest $LogCount `
            |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv `
            "c:\Temp\Logs\$ENV:COMPUTERNAME.Security.EventLog.csv"

            Get-Eventlog -LogName Application -Newest $LogCount `
            |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv `
            "c:\Temp\Logs\$ENV:COMPUTERNAME.Application.EventLog.csv"

            Get-Eventlog -LogName System -Newest $LogCount `
            |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv `
            "c:\Temp\Logs\$ENV:COMPUTERNAME.System.EventLog.csv"
            
            }


}

}
    
        ELSE{

    #This only works with AD computers; local for most applications
    #Note:
    # $ENV:COMPUTERNAME below is a local variable and "$Server" being the remote host name, Ex: Server1, Server2, etc.

    ForEach ($Server in $Servers) {

    IF($LogType -match "Application"){

        Write-Host "Exporting $LogType Logs from $Server to $Dest" -ForegroundColor Yellow

        $Session = New-PSSession -ComputerName $Server

        Invoke-Command -Session $Session {Get-Eventlog -LogName Application -Newest $using:LogCount `
        |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv "c:\Temp\$ENV:COMPUTERNAME.Application.EventLog.csv"}

        Write-Host "Saving to $Dest as $Server.Application.EventLog.csv"

        Copy-Item -Path "\\$Server\c$\Temp\Logs\$Server.Application.EventLog.csv" -Destination $Dest -Force

        remove-item -Path "\\$Server\c$\Temp\Logs\$Server.Application.EventLog.csv" -Force  |out-null

}

    IF($LogType -match "System"){

        Write-Host "Exporting $LogType Logs from $Server to $Dest" -ForegroundColor Yellow

        $Session = New-PSSession -ComputerName $Server

        Invoke-Command -Session $Session {Get-Eventlog -LogName System -Newest $using:LogCount `
        |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv "c:\Temp\$ENV:COMPUTERNAME.System.EventLog.csv"}

        Write-Host "Saving to $Dest as $Server.System.EventLog.csv"

        Copy-Item -Path "\\$Server\c$\Temp\Logs\$Server.System.EventLog.csv" -Destination $Dest -Force

        remove-item -Path "\\$Server\c$\Temp\Logs\$Server.System.EventLog.csv" -Force  |out-null

}

    IF($LogType -match "Security"){

        Write-Host "Exporting $LogType Logs from $Server to $Dest" -ForegroundColor Yellow

        $Session = New-PSSession -ComputerName $Server

        Invoke-Command -Session $Session {Get-Eventlog -LogName Security -Newest $using:LogCount `
        |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv "c:\Temp\$ENV:COMPUTERNAME.Security.EventLog.csv"}

        Write-Host "Saving to $Dest as $Server.Setup.EventLog.csv"

        Copy-Item -Path "\\$Server\c$\Temp\Logs\$Server.Security.EventLog.csv" -Destination $Dest -Force

        remove-item -Path "\\$Server\c$\Temp\Logs\$Server.Security.EventLog.csv" -Force |out-null

}

    IF($LogType -match "All"){

            #Creates PS-Sessions for each server.
            #Note:
            # Servers need WinRM enabled
            # https://docs.microsoft.com/en-us/windows/win32/winrm/installation-and-configuration-for-windows-remote-management

            # Need PS Remoting enabled
            # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-6

            Write-Host "Exporting $LogType Logs from $Server to $Dest" -ForegroundColor Yellow

            $Session1 = New-PSSession -ComputerName $Server

            $Session2 = New-PSSession -ComputerName $Server

            $Session3 = New-PSSession -ComputerName $Server

            Invoke-Command -Session $Session1 {Get-Eventlog -LogName Security -Newest $using:LogCount `
            |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv "c:\Temp\Logs\$ENV:COMPUTERNAME.Security.EventLog.csv"}

            Invoke-Command -Session $Session2 {Get-Eventlog -LogName Application -Newest $using:LogCount `
            |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv "c:\Temp\Logs\$ENV:COMPUTERNAME.Application.EventLog.csv"}

            Invoke-Command -Session $Session3 {Get-Eventlog -LogName System -Newest $using:LogCount `
            |Select-Object TimeGenerated, MachineName, EventID, EntryType, Message| Export-Csv "c:\Temp\Logs\$ENV:COMPUTERNAME.System.EventLog.csv"}

            Write-Host "Saving to $Dest as $Server.Security.EventLog.csv"

            Copy-Item -Path "\\$Server\c$\Temp\Logs\$Server.Security.EventLog.csv" -Destination $Dest -Force

            Write-Host "Saving to $Dest as $Server.Application.EventLog.csv"

            Copy-Item -Path "\\$Server\c$\Temp\Logs\$Server.Application.EventLog.csv" -Destination $Dest -Force

            Write-Host "Saving to $Dest as $Server.System.EventLog.csv"

            Copy-Item -Path "\\$Server\c$\Temp\Logs\$Server.System.EventLog.csv" -Destination $Dest -Force

            remove-item -Path "\\$Server\c$\Temp\Logs\$Server.Security.EventLog.csv" |out-null

            remove-item -Path "\\$Server\c$\Temp\Logs\$Server.Application.EventLog.csv" |out-null

            remove-item -Path "\\$Server\c$\Temp\Logs\$Server.System.EventLog.csv" |out-null

}

}
        
        }

ii "c:\Temp\Logs"





