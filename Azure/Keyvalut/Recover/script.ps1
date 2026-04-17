param(
    [Parameter(Mandatory = $true)]
    [string] $VaultName,

    [Parameter(Mandatory = $true)]
    [string] $SecretNames
)

Write-Host "======================================"
Write-Host "Key Vault Secret Recovery"
Write-Host "Vault : $VaultName"
Write-Host "======================================"

# -------------------------------------
# Helper: Normalize single/multiple input
# -------------------------------------
function Normalize-Secrets ($input) {
    return $input.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

$Secrets = Normalize-Secrets $SecretNames

if ($Secrets.Count -eq 0) {
    throw "No secret names provided for recovery."
}

foreach ($SecretName in $Secrets) {

    Write-Host "Recovering secret [$SecretName] in vault [$VaultName]"

    Undo-AzKeyVaultSecretRemoval `
        -VaultName $VaultName `
        -Name $SecretName `
        -ErrorAction Stop

    Write-Host "Secret [$SecretName] recovered successfully"
}

Write-Host "Recovery operation completed."
