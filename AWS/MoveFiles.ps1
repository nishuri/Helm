# Define variables.
$pemFile      = "C:\Users\Administrator\Desktop\transfertest.pem"
$sourceFolder = "C:\Users\Administrator\Documents\Random"
$targetUser   = "ec2-user"
$targetIP     = "15.207.115.227"
$targetFolder = "/home/transfertest"

# Checking if source folder exists.
if (!(Test-Path $sourceFolder)) {
    Write-Error "Source folder '$sourceFolder' does not exist. Exiting..."
    exit 1
}

# Checking PEM file exists.
if (!(Test-Path $pemFile)) {
    Write-Error "PEM file '$pemFile' not found. Exiting..."
    exit 1
}

$remoteDestination = "${targetUser}@${targetIP}:${targetFolder}"

Write-Output "Transferring contents of $sourceFolder to $remoteDestination recursively..."

# Use SCP with the -r option to copy everything (files and subdirectories).
# The wildcard (*) transfers all content inside the source folder.
& scp -r -i $pemFile ("${sourceFolder}\*") $remoteDestination

if ($LASTEXITCODE -eq 0) {
    Write-Output "Files and subdirectories transferred successfully."
    Write-Output "Removing local files and directories from $sourceFolder..."
    
    # Remove all items
    Remove-Item "${sourceFolder}\*" -Recurse -Force
    
    Write-Output "Local files have been removed; the transfer operation is success."
} else {
    Write-Error "Error transferring files. Exit code: $LASTEXITCODE"
}
