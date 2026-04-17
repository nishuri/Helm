param(
    [Parameter(Mandatory = $true)]
    [string] $VaultName,

    [Parameter(Mandatory = $true)]
    $SecretNames
)

Write-Host "======================================"
Write-Host "Key Vault Secret Deletion"
Write-Host "Vault : $VaultName"
Write-Host "======================================"

# -------------------------------------
# Helper: Normalize single/multiple input
# -------------------------------------
function Normalize-Secrets ($input) {
    if ($input -is [string]) {
        return $input.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    }
    else {
        return $input | ForEach-Object { "$_".Trim() } | Where-Object { $_ }
    }
}

$Secrets = Normalize-Secrets $SecretNames

if ($Secrets.Count -eq 0) {
    throw "No secret names provided for deletion."
}

foreach ($SecretName in $Secrets) {

    Write-Host "Deleting secret [$SecretName] from vault [$VaultName]"

    Remove-AzKeyVaultSecret `
        -VaultName $VaultName `
        -Name $SecretName `
        -Force `
        -ErrorAction Stop

    Write-Host "Secret [$SecretName] soft-deleted successfully"
}

Write-Host "Deletion operation completed."
