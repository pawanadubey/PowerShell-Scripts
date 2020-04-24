$file=Read-Host "Please give file path consist of FQDN of servers to be in maintenance mode"
$servers=Get-Content $file
$MaintenanceTime=Read-Host "Number of minutes for maintenance"
$Reason=Read-Host "Reason for Maintenance"
$i=0
foreach($server in $servers)
{
    $i++
    $Instance = Get-SCOMClassInstance -Name $server
    $Time = ((Get-Date).AddMinutes($MaintenanceTime))
    Start-SCOMMaintenanceMode -Instance $Instance -EndTime $Time -Comment $Reason -Reason "PlannedOther"
    $mode=$Instance.InMaintenanceMode
    Write-Progress -Activity “Server: $server” -status “Completed” -percentComplete ($i / $servers.count*100)
   
}