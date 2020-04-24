function Get-Hash
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $filePath
    )

    Begin
    {
        if( -Not( Test-Path $filePath)){
            Write-Host "Given file path $filePath is not valid." -ForegroundColor Red
            break 
        }
    }
    Process
    {
        $fileStream = [system.io.file]::openread($filePath)
	    $algorithm = [System.Security.Cryptography.HashAlgorithm]::create("md5")
	    $getHash = $algorithm.ComputeHash($fileStream)
	    $fileStream.Close()
	    $hash = ([system.bitconverter]::tostring($getHash)).Replace("-","")
    }
    End
    {
        return $hash
    }
}
function Get-AllFiles
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $folderPath
    )

    Begin
    {
        if( -Not( Test-Path $folderPath)){
            Write-Host "Given folder path $folderPath is not valid." -ForegroundColor Red
            break 
        }
    }
    Process
    {
        Write-Host "Getting all the files in folder $folderPath ..." -ForegroundColor DarkCyan
        $rawFilePaths=Get-ChildItem -Path $folderPath -Recurse -Filter *.* | where { ! $_.PSIsContainer }
        $filePaths=New-Object Collections.Generic.List[String];
        foreach($rawFilePath in $rawFilePaths){
            $filePaths.Add(($rawFilePath.FullName).Replace($folderPath,""))
        }
    }
    End
    {
        return $filePaths
    }
}
function Sync-Folders
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $sourceFolder,
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        $destinationFolder
    )
    Begin
    {
        if( -Not(Test-Path $sourceFolder)){
            Write-Host "Given source folder path $sourceFolder is not valid." -ForegroundColor Red
            break 
        }
        if( -Not(Test-Path $destinationFolder)){
            Write-Host "Given destination folder path $destinationFolder is not valid." -ForegroundColor Red
            break 
        }
    }
    Process
    {
        try{
            $sourceFiles = Get-AllFiles -folderPath $sourceFolder
            $desFiles=Get-AllFiles -folderPath $destinationFolder
            foreach($sourceFile in $sourceFiles){
            $desiredFilePath=$destinationFolder +"\" + $sourceFile
            $sourceFilePath = $sourceFolder+"\"+$sourceFile
            $desiredFilePath = $desiredFilePath.Replace('\\','\');
            $sourceFilePath = $sourceFilePath.Replace('\\','\');
            if( -Not(Test-Path $desiredFilePath)){
                $desiredFolderPath=[System.IO.Path]::GetDirectoryName($desiredFilePath)
                if(-Not(Test-Path $desiredFolderPath)){
                    New-Item -Path $desiredFolderPath -ItemType Directory -Force
                }
                Write-Host "`nFile $desiredFilePath not found.`nCopying it." -ForegroundColor DarkCyan
                Copy-Item -Path $sourceFilePath -Destination $desiredFilePath -Force -Recurse
            }
            else{
                $destinationHash=Get-Hash -filePath $desiredFilePath
                $sourceHash=Get-Hash -filePath  $sourceFilePath
                if($destinationHash -ne $sourceHash){
                    Write-Host "`nContent of $desiredFilePath file is different.`nReplacing it." -ForegroundColor DarkCyan
                    Remove-Item -LiteralPath $desiredFilePath -Force
                    Copy-Item -LiteralPath $sourceFilePath -Destination $desiredFilePath
                }
            }
        }
        }
        catch{
            $exception = $_.Exception
            $exceptionMessage = $exception.Message
            Write-Host "`n`nException Occured: $exceptionMessage" -ForegroundColor Red
            break
        }
        
    }
    End
    {
        Write-Host "`nSync from $sourceFolder to $destinationFolder completed" -ForegroundColor Green
        $deleteOtherFiles=Read-Host "`n`nDo you want to delete the files in $destinationFolder which are not present in $sourceFolder ? (y/n)"
        if($deleteOtherFiles.ToLower() -eq 'y'){
            foreach($desFile in $desFiles){
                $desiredFilePath=$destinationFolder.TrimEnd('\') +"\" + $desFile
                $sourceFilePath = $sourceFolder.TrimEnd('\')+"\"+$desFile
                    if( -Not(Test-Path $sourceFilePath)){
                        Remove-Item -LiteralPath $desiredFilePath -Force
                    }
            }
        }
        Write-Host "`nTask completed." -ForegroundColor DarkCyan
        Write-Host "`n`nNot all the time you need to purchase applications to do the stuffs ;)" -ForegroundColor Gray
    }
}
Sync-Folders