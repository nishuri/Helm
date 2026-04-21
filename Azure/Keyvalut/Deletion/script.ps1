param(
    [Parameter(Mandatory = $true)]
    [string]$VaultName,
	
	[Parameter(Mandatory = $true)]
    [ValidateSet("Delete", "Disable")]
    [string] $Operation,

    [Parameter(Mandatory = $true)]
    [string]$SecretNames
)

Write-Host "==============================="
Write-Host "Key Vault Secret Deletion"
Write-Host "Vault : $VaultName"
Write-Host "==============================="
Write-Host "SecretNames: $SecretNames"

if ([string]::IsNullOrWhiteSpace($SecretNames)) {
    Write-Error "No secret names provided for deletion."
    exit 1
}

$secretList = $SecretNames.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

if (-not $secretList -or $secretList.Count -eq 0) {
    Write-Error "No valid secret names found after parsing input."
    exit 1
}

if ($Operation -eq "Delete") {

	foreach ($secretName in $secretList) {
		Write-Host "Deleting secret: $secretName"

		$secret = Get-AzKeyVaultSecret -VaultName $VaultName -Name $secretName -ErrorAction SilentlyContinue

		if (-not $secret) {
			Write-Warning "Secret '$secretName' not found in vault '$VaultName'. Skipping."
			continue
		}

		Remove-AzKeyVaultSecret -VaultName $VaultName -Name $secretName -Force
		Write-Host "Deleted secret: $secretName"
	}
}

if ($Operation -eq "Disable") {

	foreach ($secretName in $secretList) {
		Write-Host "Disabling secret: $secretName"

		$secret = Get-AzKeyVaultSecret -VaultName $VaultName -Name $secretName -ErrorAction SilentlyContinue

		if (-not $secret) {
			Write-Warning "Secret '$secretName' not found in vault '$VaultName'. Skipping."
			continue
		}

		Update-AzKeyVaultSecret -VaultName $VaultName -Name $secretName -Enable $false
		Write-Host "Disaled secret: $secretName"
	}
}
