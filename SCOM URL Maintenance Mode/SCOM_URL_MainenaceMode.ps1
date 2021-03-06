$urls=Get-Content "C:\URLs.txt"
$MaintenanceTime=Read-Host "Number of minutes for maintenance"
$Reason=Read-Host "Reason for Maintenance"
foreach($url in $urls)
{
    $Instance = (Get-SCOMClass -name Microsoft.SystemCenter.WebApplication.Perspective) | Get-SCOMClassInstance | where-object {$_.DisplayName -eq $url}
    $url
    $Instance.InMaintenanceMode
    Write-Progress -Activity "URL added in maintenance" -Status "$url"
}