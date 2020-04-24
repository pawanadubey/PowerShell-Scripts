<#
.Synopsis
   Zip your folder
.DESCRIPTION
   This PowerShell tool is useful to archive, compress a given folder in zip.
.EXAMPLE
   It is more of GUI kind tool, so just sit back and relax.
#>

Function Get-FolderName{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.ShowDialog()
    $folder=$foldername.SelectedPath
    return $folder
}



function Set-Zip
{
    Param
    (

        $sourcedir
    )
    
    Begin
        {
            $rawZipFile=$sourcedir[2]
            $zipFileName=$rawZipFile+".zip"
            Write-Host "Zip file name" $zipFileName
        }

    Process
        {

            Add-Type -Assembly System.IO.Compression.FileSystem
            #$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
            #[System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,$zipfilename, $compressionLevel, $false)
            [System.IO.Compression.ZipFile]::CreateFromDirectory($rawZipFile,$zipfilename)
            
        }

    End
        {
            if(Test-Path $zipFileName){
                Write-Host "Zip file created successfully." -ForegroundColor Green

            }
            else{
                Write-Host "Something went wrong, please try again." -ForegroundColor Red
            }
            
        }

        
}
$folderName=Get-FolderName
Set-Zip -sourcedir $folderName