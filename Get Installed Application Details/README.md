The script is useful to get details of installed apps on multiple servers.

It is very easy to use, run the script with PowerShell, it will ask for a file with server list and folder path where the output to be saved.

The script shows progress and once completed the output is saved in csv format with Vendor, Version, Installed Date, Install Location and Product ID.

PowerShell

$filePath=Read-Host "Please give file path having server names" 
$outputFile=Read-Host "Please give folder path where output to be saved" 
$output="Server, Caption, Vendor, Version, InstallDate, InstallLocation, ProductID" 
if(Test-Path $filePath){ 
    $servers=Get-Content $filePath 
    $total=$servers.Count 
    $index=0 
    foreach($server in $servers){ 
        Write-Progress -Activity "Fetching details for server $server" -Status "Starting..." -PercentComplete (($index * 100)/$total); 
        Write-Host "Fetching details for server: $server" -ForegroundColor Green 
        $infos=Get-WmiObject -Class Win32_Product -ComputerName $server 
        foreach($info in $infos){ 
            $output=$output +"`n"+$info.PSComputerName+","+$info.Caption+","+$info.Vendor+","+$info.Version+","+$info.InstallDate+","+$info.InstallLocation+","+$info.ProductID 
        } 
        $index++ 
        Write-Progress -Activity "Details fetched for server $server" -Status "Completed..." -PercentComplete (($index * 100)/$total); 
    } 
 
    Add-Content -Value $output -Path $outputFile\InstalledApps.csv 
}

