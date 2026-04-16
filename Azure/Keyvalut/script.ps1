#Source Information
$sourceVaultName = "EDAV-DEV-KVault-WEU"
$sourceSubscriptionId = "ESFA-DataSci-Dev"
$sourceTenantId = "1a92889b-8ea1-4a16-8132-347814051567"

#Authenticate to Source Keyvault
Connect-AzAccount -Tenant $sourceTenantId -Subscription $sourceSubscriptionId 

#GetSecret from Source Keyvault
$secrets=Get-AzKeyVaultSecret -VaultName $sourceVaultName -Name 'VYED-NotifyVMFI-Key'

#DestinationInformation
$destVaultName = "s148d01-kv-dtp-01"
$destSubscriptionId = "s148-vyed-development"
$destTenantId = "9c7d9dd3-840c-4b3f-818e-552865082e16"

#Authenticate to Destination Keyvault
Connect-AzAccount -Tenant $destTenantId -Subscription $destSubscriptionId

#Loop and Copy each in Destination

foreach ($secret in $secrets)
{
    #set variables
    $secretName = $secret.Name
    $secretValue = $secret.SecretValue
    if ($secret.Expires -ne $null)
    {
        $secretExpires = $secret.Expires
    }
    if ($secret.ContentType -ne $null)
    {
        $contentType=$secret.ContentType
    }

    #Create Secret in Destination Key Vault
    
    if ($secretExpires -ne $null -and $contentType -ne $null)
    {
        Set-AzKeyVaultSecret -VaultName $destVaultName -Name $secretName -SecretValue $secretValue -ContentType $contentType -Expires $secretExpires
    }
    elseif ($secret.Expires -ne $null)
    {
        Set-AzKeyVaultSecret -VaultName $destVaultName -Name $secretName -SecretValue $secretValue -ContentType $contentType
    }
    elseif ($secret.ContentType -ne $null)
    {
        Set-AzKeyVaultSecret -VaultName $destVaultName -Name $secretName -SecretValue $secretValue -Expires $secretExpires
    }
    else
    {
        Set-AzKeyVaultSecret -VaultName $destVaultName -Name $secretName -SecretValue $secretValue 
    }

    #Drop variables
    $secretName = $null
    $secretValue = $null
    $secretExpires = $null
    $contentType = $null
}

#Disconnect Source Tenant
Disconnect-AzAccount

#Disconnect Destination Tenant
Disconnect-AzAccount