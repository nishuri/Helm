$srcPath = "C:\ServiceNow MID Server Azure_MID\agent\export\bcm"
$destPath = "Z:\"

robocopy $srcPath $destPath /MOVE /E

if ($LASTEXITCODE -ge 8) {
    Write-Error "Robocopy encountered an error with exit code $LASTEXITCODE"
} else {
    Write-Output "Files moved successfully. Robocopy exit code: $LASTEXITCODE"
}
