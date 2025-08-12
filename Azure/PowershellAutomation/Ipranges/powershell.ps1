param(
    [Parameter(Mandatory = $true)]
    [string]$storageAccountName,

    [Parameter(Mandatory = $true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$name
)

# Importing Analysis Service Modules
Write-Host "Getting PowerShell Module"
Import-Module Az.Storage

$response = Invoke-WebRequest "https://www.microsoft.com/en-us/download/details.aspx?id=56519"
$fileStartIndex = $response.Content.IndexOf("ServiceTags_Public_")
$fileEndIndex = $response.Content.IndexOf(".json", $fileStartIndex)
$fileName = $response.Content.Substring($fileStartIndex, $fileEndIndex - $fileStartIndex)
$downloadLink = "https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/$fileName.json"
$data = Invoke-RestMethod $downloadLink

$addresses = @()
$filteredAddresses = @()

foreach ($item in $data.values) {
    if ($item.name -eq $name) {
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
    $ipRange = @{
        IPAddressOrRange = $modifiedIp
        Action = "allow"
    }
    $ipRanges += $ipRange
}

Write-Host "Updating storage account $storageAccountName netowrking"

try {
    Add-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroupName -Name $storageAccountName -IPRule $ipRanges
    } 
    catch {
        Write-Host "Error adding IP rules - $_"
          }

Write-Host "IP rules added successfully to storage account $storageAccountName"
