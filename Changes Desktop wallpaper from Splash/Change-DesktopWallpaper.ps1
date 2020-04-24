<#
.Synopsis
   Changes Desktop wallpaper from splashbase
.DESCRIPTION
   The script downloads random images from http://www.splashbase.co/ in your temparory folder and sets the image as your desktop wallpaper.
.EXAMPLE
   Change-DesktopWallpaper
.EXCEPTION
   Sometimes the api returns videos, in those cases the wallpaper wont be changed.
#>
function Change-DesktopWallpaper
{

    Begin
    {
        Write-Host "Initiating the process"
        $baseURL="http://www.splashbase.co/api/v1/images/random"
        $tempFolder=[System.IO.Path]::GetTempPath()
        $imageFilePath=""
        $regPath="HKCU:\Control Panel\Desktop\"
        $regName="wallpaper"
        $webResponse=$null
    }
    Process
    {
        $webResponse=Invoke-WebRequest -Uri $baseURL
        if($webResponse.StatusCode -eq 200){
            $responseContent=$webResponse.Content | ConvertFrom-Json
            $imageURL=$responseContent.large_url
            if(($imageURL -ne "") -and ($imageURL.EndsWith('png') -or $imageURL.EndsWith('jpg') -or $imageURL.EndsWith('jpeg') )){
                $tempFolder=[System.IO.Path]::GetTempPath();
                Write-Host "Downloading image" -ForegroundColor Green
                Start-BitsTransfer -Source $imageURL -Destination $tempFolder -TransferType Download
                Write-Host "Image download completed" -ForegroundColor Green
                $imageName=$imageURL.Split('/')[-1]
                $imageFilePath=Join-Path -Path $tempFolder -ChildPath $imageURL.Split('/')[-1]
                Set-ItemProperty -path $regPath -name $regName -value $imageFilePath -Force
                rundll32.exe user32.dll, UpdatePerUserSystemParameters
                Write-Host "Successfully changed the desktop wallpaper" -ForegroundColor Green
            }
            else{
                Write-Host "Could not find image" -ForegroundColor Red
            }
        }
        else{
            Write-Host "Could not connect to "$baseURL  -ForegroundColor Red
        }
    }
    End
    {
        Write-Host "Cleaning up..."
        Clear-Variable baseURL, tempFolder, regPath, regName, webResponse
    }
}

Change-DesktopWallpaper