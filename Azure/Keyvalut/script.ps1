param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Delete", "Recover")]
    [string] $Operation,

    [Parameter(Mandatory = $true)]
    [string] $VaultName,

    [Parameter(Mandatory = $true)]
    [string] $SecretNames
)

Write-Host "======================================"
Write-Host "Key Vault Secret Decommissioning"
Write-Host "Operation : $Operation"
Write-Host "Vault     : $VaultName"
Write-Host "======================================"

# -------------------------------------
# Helper: Normalize single/multiple input
# -------------------------------------
function Normalize-Secrets ($input) {
    return $input.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

$Secrets = Normalize-Secrets $SecretNames

if ($Secrets.Count -eq 0) {
    throw "No secret names provided."
}

# -------------------------------------
# DELETE MODE (Soft Delete)
# -------------------------------------
if ($Operation -eq "Delete") {

    foreach ($SecretName in $Secrets) {

        Write-Host "Deleting secret [$SecretName] from vault [$VaultName]"

        Remove-AzKeyVaultSecret `
            -VaultName $VaultName `
            -Name $SecretName `
            -Force `
            -ErrorAction Stop

        Write-Host "Secret [$SecretName] soft-deleted successfully"
    }

    return
}

# -------------------------------------
# RECOVER MODE
# -------------------------------------
if ($Operation -eq "Recover") {

    foreach ($SecretName in $Secrets) {

        Write-Host "Recovering secret [$SecretName] in vault [$VaultName]"

        Undo-AzKeyVaultSecretRemoval `
            -VaultName $VaultName `
            -Name $SecretName `
            -ErrorAction Stop

        Write-Host "Secret [$SecretName] recovered successfully"
    }

    return
}
