Login-AzureRmAccount

Get-AzureRmResourceGroup

New-AzureRmResourceGroup -Name FileStorageRG -Location westus2

New-AzureRmStorageAccount -ResourceGroupName FileStorageRG -Name filestorageacc -Location westus2 -SkuName Standard_LRS

$storageKey= Get-AzureRmStorageAccountKey -ResourceGroupName FileStorageRG -Name filestorageacc

$storageKey

$key1=$storageKey[0].Value

$key1

$storageContext=New-AzureStorageContext -StorageAccountName filestorageacc -StorageAccountKey $key1

$storageContext

New-AzureStorageShare -Name examplefileshare -Context $storageContext

Get-AzureStorageShare -Name examplefileshare -Context $storageContext

Get-AzureStorageFile -ShareName examplefileshare -Context $storageContext

New-AzureStorageDirectory -ShareName examplefileshare -Context $storageContext -Path "Images"

Set-AzureStorageFileContent -ShareName examplefileshare -Source "F:\Yummy.jpg" -Path "Images" -Context $storageContext

Get-AzureStorageFile -ShareName examplefileshare -Path "Images" -Context $storageContext | Get-AzureStorageFile