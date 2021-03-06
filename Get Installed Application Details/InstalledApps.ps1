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