# Get-Event-Logs
Dumps local or remote events to .CSV files to Temp dir.

 .SYNOPSIS 
     Queries listed or inputed servers and checks for specified Logs based on days and log type; outputs via the $Dest variable.
  
 .DESCRIPTION 
     Runs 2 ways:
     1. Load serverNames into a text file; alter this command under the $Computers variable, then run. Logs made.
     2. Answer prompts to obtain output to /Temp folder
     
 .PARAMETERS
     $Servers: Server(s) to query; Can be 'localhost' or remote, separated by a comma " , " [WinRM required to be installed on remote hosts].

     $Dest: Change this to where you want the Logs exported

     $LogType: List Log type needed

     $LogCount: Number of entries to go back
 
 ![image](https://user-images.githubusercontent.com/22520564/209152289-2b427f23-cbc1-4140-9877-9863b21f6d8d.png)


 
 ![image](https://user-images.githubusercontent.com/22520564/209152087-8d30baab-b1a0-4a77-98a8-dc50791d4806.png)

 
 For More info:
 https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-eventlog?view=powershell-5.1
 
