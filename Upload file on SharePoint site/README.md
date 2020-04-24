In todays world, we get multiple reports, which need to be uploaded to a central repository (SharePoint). Uploading the same manually can waste your valuable time.

This is PowerShell script to upload files on SharePoint.

Below is the script.

 

#Credential if required

$credentials = Get-Credential

$webclient = New-Object System.Net.WebClient$webclient.Credentials = $credentials

#Destination URL$destination = "http://spweb.example.com/sites/Reports/Daily”

#Source File to be uploaded

$File = get-childitem D:\File1.pdf

#Uploading

$webclient.UploadFile($destination + "/" + $File.Name, "PUT", $File.FullName)