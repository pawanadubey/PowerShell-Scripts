The script is having functions and takes ComputerName as parameter. The function name and description is as below.

1. Get-RebootBoolean: It will return True if the server experienced a reboot in last 2 hours else will return False.

PowerShell

#Syntax 
Get-RebootBoolean -ComputerName "abc.contoso.com"

2. Get-ProcessorBoolean: It will return True if the process utilization is equal to or more than 90% else will return False.

PowerShell

#Syntax  
Get-ProcessorBoolean -ComputerName "abc.contoso.com"

3. Get-MemoryBoolean: It will return True if the memoryutilization is equal to or more than 90% else will return False.

PowerShell

#Syntax   
Get-MemoryBoolean -ComputerName "abc.contoso.com"

4. Get-DiskSpaceBoolean: It will return True if the disk space utilization is equal to or more than 90% else will return False.

PowerShell

#Syntax    
Get-DiskSpaceBoolean -ComputerName "abc.contoso.com"

5. Get-NotRunningServices: It will return True if the any service which is having Start Up type as Automatic and is not running else will return False.
PowerShell

#Syntax     
Get-NotRunningServices -ComputerName "abc.contoso.com"

 
You can change the threshold in the script to get desired output.