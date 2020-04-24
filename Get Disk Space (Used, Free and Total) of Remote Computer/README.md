This script gets the information about the disk space of the given remote computer.

The outcome will have drive name, used space, free space and total space in GBs.

 

Below is the example.

Get-RemoteComputerDisk -RemoteComputerName "abc.contoso.com"   

Drive    UsedSpace(in GB)    FreeSpace(in GB)    TotalSpace(in GB)   

C          75                          52                          127   

D          28                          372                        400