#Credential if required
$credentials = Get-Credential
$webclient = New-Object System.Net.WebClient
$webclient.Credentials = $credentials
#Destination URL
$destination = "http://spweb.ccs.utc.com/sites/WHQITInfra/Shared Documents/SCOM Reports/Chiller/Daily/$foldername”
#Source File to be uploaded
$File = get-childitem $directory\Chiller_Availability_Daily_Report_$a.pdf
#Uploading
$webclient.UploadFile($destination + "/" + $File.Name, "PUT", $File.FullName)
