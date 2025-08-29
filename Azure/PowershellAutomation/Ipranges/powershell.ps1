param(
    [Parameter(Mandatory = $true)]
    [string]$storageAccountName,

    [Parameter(Mandatory = $true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$regionName
)


Write-Host "Getting PowerShell Module"
Import-Module Az.Storage -ErrorAction Stop

$ErrorActionPreference = "Stop"

$response = Invoke-WebRequest "https://www.microsoft.com/en-us/download/details.aspx?id=56519"
$fileStartIndex = $response.Content.IndexOf("ServiceTags_Public_")
$fileEndIndex = $response.Content.IndexOf(".json", $fileStartIndex)
$fileName = $response.Content.Substring($fileStartIndex, $fileEndIndex - $fileStartIndex)
$downloadLink = "https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/$fileName.json"
$data = Invoke-RestMethod $downloadLink

$addresses = @()
$filteredAddresses = @()

foreach ($item in $data.values) {
    if ($item.name -eq $regionName) {
        foreach ($ip in $item.properties.addressPrefixes) {
            $addresses += $ip
            }
        }
    }

foreach ($address in $addresses) {
    if ($address -notmatch ":") {
        $filteredAddresses += $address
        }
    }
 
$ipRanges = @()

foreach ($ip in $filteredAddresses) {
    if ($ip -match "/31$|/32$") {
        $modifiedIp = $ip -replace "/(31|32)$", ""
    } else {
        $modifiedIp = $ip
    }
    $ipRanges += $modifiedIp
}

Write-Host "Updating storage account $storageAccountName netowrking"

$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
$currentRules = $storageAccount.NetworkRuleSet.IpRules
$currentRuleIps = $currentRules | ForEach-Object { $_.IPAddressOrRange }

$currentCount = $currentRuleIps.Count
$maxLimit = 400
$remaining = $maxLimit - $currentCount

Write-Host "Storage account already has $currentCount rules. Remaining capacity: $remaining"

if ($remaining -le 0) {
    Write-Host "No capacity left to add IP rules. Skipping..."
    return
}

$newIps = $ipRanges | Where-Object { $currentRuleIps -notcontains $_ }

Write-Host "New IPs to add: $($newIps.Count)"

# Add only up to available capacity
$toAdd = $newIps | Select-Object -First $remaining

foreach ($range in $toAdd) {
    try {
        Add-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroupName -Name $storageAccountName -IPAddressOrRange $range -ErrorAction Stop | Out-Null
        Write-Host "Added $range successfully"
    } 
    catch {
        Write-Host "Error adding $range - $_"
    }
}

# Report skipped IPs if any
if ($ipRanges.Count -gt $remaining) {
    $skipped = $ipRanges.Count - $remaining
    Write-Host "Skipped $skipped IP(s) because the storage account reached the 400 rule limit."
}
