<#
.Synopsis
   Powershell tool for GUI way for getting CPU, Memory and Disk of remote computers.
.DESCRIPTION
   The tool will ask for file(containing servers name) and folder(where the output will be saved as ServerrInventory.csv.
.EXAMPLE
   It is tool, and has forms and buttons to help you.
.NOTES    
    Author: Pawan Dubey
    Email : pawanadubey@gmail.com
    Version: 0.1 
    DateCreated: 29 Nov 2017
#>

function Get-RemoteComputerDisk
{
    
    Param
    (
        [Parameter(Mandatory=$true)]
        $RemoteComputerName
    )

    Begin
    {
        $output=""
    }
    Process
    {
        $drives=Get-WmiObject Win32_LogicalDisk -ComputerName $RemoteComputerName

        foreach ($drive in $drives){
            
            $drivename=$drive.DeviceID -split ":"
            if(($drivename -ne "A") -and ($drivename -ne "B")){
                $freespace=[int]($drive.FreeSpace/1GB)
                $totalspace=[int]($drive.Size/1GB)
                $usedspace=$totalspace - $freespace
                $output=$output+$drivename+"("+$totalspace+"GB),"
            }
        }
    }
    End
    {
        return $output
    }
}

function Get-RemoteComputerCPU
{
    
    Param
    (
        [Parameter(Mandatory=$true)]
        $RemoteComputerName
    )

    Begin
    {
        $output=""
    }
    Process
    {
        $cpu=Get-WmiObject Win32_Processor -ComputerName $RemoteComputerName
        $name=$cpu.Name
        $output=$name
        
    }
    End
    {
        return $output
    }
}

function Get-RemoteComputerRAM
{
    
    Param
    (
        [Parameter(Mandatory=$true)]
        $RemoteComputerName
    )

    Begin
    {
        $output=""
    }
    Process
    {
        $ram=Get-WmiObject -Class Win32_ComputerSystem -ComputerName $RemoteComputerName
        $physicalMemory=($ram.TotalPhysicalMemory)/1GB
        $output=$physicalMemory
    }
    End
    {
        return $output
    }
}

Function Get-FileName()
{  
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Select the file"
    $OpenFileDialog.filter = "All files (*.*)| *.*"
    $OpenFileDialog.ShowDialog()
    $OpenFileDialog.filename
}


Function Get-FolderName(){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.ShowDialog()
    $foldername.SelectedPath
}


Read-Host "Press any key to start"
$serversFile=(Get-FileName)[2]
$servers=Get-Content $serversFile
$outputFolder=(Get-FolderName)[2]
$outputFile=$outputFolder+"\ServerInventory.csv"
Write-Host "Checking whether ServerInventory.csv file exists" -ForegroundColor Green
if(Test-Path $outputFile)
{
    Read-Host "Press any key to delete the ServerInventory.csv file or exit"
    Remove-Item $outputFile -Force
}

Write-Host "Starting ..." -ForegroundColor Green

$output="ServerName,CPU,RAM,Disk"
foreach($server in $servers)
{
    Write-Host "On server: "$server" ..." -ForegroundColor Green
    $cpu=Get-RemoteComputerCPU -RemoteComputerName $server
    $ram=Get-RemoteComputerRAM -RemoteComputerName $server
    $disks=Get-RemoteComputerDisk -RemoteComputerName $server
    $output += "`n"+$server+","+$cpu+","+$ram+","+$disks
}

Write-Host "Creating ServerInventory.csv file" -ForegroundColor Green
Add-Content -Value $output -Path $outputFile

Write-Host "Completed `n Please check $outputFile." -ForegroundColor Gray