# Get-Event-Logs
Dumps local or remote events to a csv file

 .SYNOPSIS 
     Queries listed or inputed servers and checks for specified Logs based on days and log type; outputs via the $Dest variable.
  
 .DESCRIPTION 
     Load serverNames into a text file; alter this command under the $Computers variable, then run. Logs made.
     
 .PARAMETERS
     $Servers: Server(s) to query; Can be local or remote.  Remote needs to be separated by a comma " , "

     $Dest: Change this to where you want the Logs exported

     $LogType: List Log type needed

     $LogCount: Number of entries to go back
     
 For More info:
 https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-eventlog?view=powershell-5.1
 
