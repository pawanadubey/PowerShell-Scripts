Login-AzureRmAccount
$resources=Get-AzureRmResource
$output=@()
foreach ($resource in $resources)
{
    $resourceDetails=@{
        'ResourceName'=$resource.ResourceName;
        'ResourceType'=$resource.ResourceType;
        'ResourceGroupName'=$resource.ResourceGroupName;
        'Location'=$resource.Location
    }

    $output += New-Object –TypeName PSObject –Prop $resourceDetails
}

$output | Export-Csv D:\Resources.csv -NoTypeInformation