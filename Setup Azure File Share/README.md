Azure File Share is an awesome feature of Azure for sharing your files with all your computers. Today we take a look at creating Azure File Share using PowerShell.

In this article, I would walk you through on how to implement Azure File Share using PowerShell.

Let’s begin.

Step 1: Login to Azure account using the command

 
PowerShell

Login-AzureRmAccount 
#or 
Add-AzureRmAccount

 

Step 2: Once you are logged-in to your account, select appropriate subscription on which you want to create Azure File Share service. In case you have an existing resource group and storage account proceed with Step 4.

The below command would create a new Resource Group on the specified location.

 
PowerShell

New-AzureRmResourceGroup -Name <ResourceGroupName> -Location <Location_Name>

 

 

Step 3: For creating a new Storage Account in a Resource Group, use the below command.

 
PowerShell

New-AzureRmStorageAccount -ResourceGroupName <ResourceGroupName> -Location <Location_Name> -SkuName <ReplicationType>

 

For more specification regarding Storage Account refer this link.

Step 4: This step is to create a Storage Context which stores the Storage Account name and Access Key as a single value, thus making it easy for us to authenticate while accessing any Storage Account.

Below command would get the Access Key information.

 
PowerShell

$storageKey=Get-AzureRmStorageAccountKey -ResourceGroupName <ResourceGroupName> -Name <StorageAccountName>

 

Now the below command would store one of the Storage Key value in a variable (in this case $key1 is the variable name).

 
PowerShell

$key1=$storageKey[0].Value


Using the Access Key and Storage Account name you can now create the Storage Context using below command.

 
PowerShell

New-AzureStorageContext -StorageAccountName <StorageAccountName> -StorageAccountKey <key>

  

Step 5: With the Storage Context created, you can now proceed with the creation of Azure File Share using the given command.

 
PowerShell

New-AzureStorageShare -Name <FileShareName> -Context <AzureStorageContext>

 

Pat Your Back, as now you have your Azure File Share ready.

Step 6: In order to have your data uploaded to the File Share, use the following command to create a Directory.

 
PowerShell

New-AzureStorageDirectory –ShareName <FileShareName> -Context <AzureStorageContext> -Path <FolderName>

 

To upload files to the created Directory, you can type-in below command.

 
PowerShell

Set-AzureStorageFileContent -ShareName <FileShareName> -Source <FilePathOnTheLocalMachine> -Path <DirectoryName> -Context <AzureStorageContext>

 

To have a visual satisfaction, you can verify the Azure File Share details on the Portal.