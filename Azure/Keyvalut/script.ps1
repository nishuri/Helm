param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Copy", "Enable", "Disable")]
    [string] $Operation,

    # Used only for COPY
    [string] $SourceVaultName,
    [string] $DestinationVaultName,
    [string] $CurrentSecretNames,
    [string] $NewSecretNames,

    # Used only for ENABLE / DISABLE
    [string] $TargetVaultName,
    [string] $TargetSecretNames
)

Write-Host "======================================"
Write-Host "Operation Selected: $Operation"
Write-Host "======================================"

# Helper: normalize single/multiple input
function Normalize-Secrets ($input) {
    return $input.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

# -----------------------------
# COPY MODE
# -----------------------------
if ($Operation -eq "Copy") {

    if (-not $CurrentSecretNames -or -not $NewSecretNames) {
        throw "Copy operation requires CurrentSecretNames and NewSecretNames"
    }

    $OldList = Normalize-Secrets $CurrentSecretNames
    $NewList = Normalize-Secrets $NewSecretNames

    if ($OldList.Count -ne $NewList.Count) {
        throw "Old and New secret count mismatch"
    }

    for ($i = 0; $i -lt $OldList.Count; $i++) {

        $OldName = $OldList[$i]
        $NewName = $NewList[$i]

        Write-Host "Copying [$OldName] -> [$NewName]"

        $SourceSecret = Get-AzKeyVaultSecret `
            -VaultName $SourceVaultName `
            -Name $OldName `
            -ErrorAction Stop

        $Params = @{
            VaultName   = $DestinationVaultName
            Name        = $NewName
            SecretValue = $SourceSecret.SecretValue
        }

        if ($SourceSecret.ContentType) { $Params.ContentType = $SourceSecret.ContentType }
        if ($SourceSecret.Expires)     { $Params.Expires     = $SourceSecret.Expires }

        Set-AzKeyVaultSecret @Params

        Write-Host "Copied successfully"
    }

    return
}

# -----------------------------
# ENABLE / DISABLE MODE
# -----------------------------
if ($Operation -in @("Enable", "Disable")) {

    if (-not $TargetSecretNames) {
        throw "$Operation operation requires TargetSecretNames"
    }

    $EnabledFlag = ($Operation -eq "Enable")

    $Secrets = Normalize-Secrets $TargetSecretNames

    foreach ($SecretName in $Secrets) {

        Write-Host "$Operation secret [$SecretName] in vault [$TargetVaultName]"

        Update-AzKeyVaultSecret `
            -VaultName $TargetVaultName `
            -Name $SecretName `
            -Enabled $EnabledFlag
    }

    return
}
