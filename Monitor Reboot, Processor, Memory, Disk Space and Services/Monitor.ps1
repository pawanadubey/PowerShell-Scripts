
function Get-RebootBoolean
{
    Param
    (
        $ComputerName
    )
    Process
    {
        
        $os = Get-WmiObject win32_operatingsystem -ComputerName $ComputerName
        $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
        $minutesUp=$uptime.TotalMinutes
   
    }
    End
    {
        if($minutesUp -le 120){
            return $true
        }else{
            return $false
        }
         
    }
}
function Get-ProcessorBoolean
{
    Param
    (
        $ComputerName
    )

    Begin
    {
    }
    Process
    {
        $value=(Get-Counter -ComputerName $ComputerName -Counter “\Processor(_Total)\% Processor Time” -SampleInterval 10).CounterSamples.CookedValue
    }
    End
    {
        if($value -ge 90){
        return $true
        }else{
        return $false
        }
    }
}
function Get-MemoryBoolean
{
    Param
    (
        $ComputerName
    )

    Process
    {
        $value=gwmi -Class win32_operatingsystem -computername $ComputerName | Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }}
    }
    End
    {
        if($value.MemoryUsage -ge 90){
            return $true
        }else{
            return $false
        }
        
    }
}

function Get-DiskSpaceBoolean
{
    Param
    (
        $freeBoolean=$false,
        $ComputerName
    )

    Process
    {
        $diskInfo=Get-WmiObject -ComputerName $ComputerName -class win32_logicaldisk
        foreach($disk in $diskInfo){
            if($disk.DeviceID -ne 'A:'){
                if(($disk.FreeSpace/$disk.Size)*100 -le 10){
                    $freeBoolean=$true
                }
            }

        }
    }
    End
    {
        $freeBoolean
    }
}


function Get-NotRunningServices
{
    
    Param
    (
        $ComputerName
    )

    
    Process
    {
        $notRunning=Get-wmiobject -ComputerName $ComputerName win32_service -Filter "startmode = 'auto' AND state != 'running' AND Exitcode !=0"
        $count=$notRunning.Count
    }
    End
    {
        if($count -ge 0){
            return $true
        }
        else{
            return $false
        }
    }
}
