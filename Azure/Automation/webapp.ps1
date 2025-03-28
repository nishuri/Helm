param (
        [Parameter(Mandatory=$true)]
        [string]$subscriptionId,
        [Parameter(Mandatory=$true)]
        [string]$resourceGroupName,
        [Parameter(Mandatory=$true)]
        [string[]]$webAppNames,
        [Parameter(Mandatory=$true)]
        [string]$functionAppName
    )

# Setting your Azure subscription
az account set --subscription $subscriptionId

# # Convert CSV string to an array if necessary.
# if ($webAppNames -is [string]) {
#     $webAppNames = $webAppNames -split ',\s*'
# }

# Get the current hour and current day
$currentHour = (Get-Date).Hour
$currentDay = (Get-Date).DayOfWeek

foreach ($webAppName in $webAppNames) {
    $webAppStatus = az webapp show --name $webAppName --resource-group $resourceGroupName --query "state" --output tsv
    Write-Output "Current status of Azure Web App $webAppName: $webAppStatus"
    
    if ($currentHour -eq 7) {
        if ($webAppStatus -eq "Stopped") {
            az webapp start --name $webAppName --resource-group $resourceGroupName
            Write-Output "Azure Web App $webAppName started successfully."
        } else {
            Write-Output "Azure Web App $webAppName is already running : No Action Taken"
        }
    } elseif ($currentHour -eq 19) {
        if ($webAppStatus -eq "Running") {
            az webapp stop --name $webAppName --resource-group $resourceGroupName
            Write-Output "Azure Web App $webAppName stopped successfully."
        } else {
            Write-Output "Azure Web App $webAppName is already stopped: No Action Taken!"
        }
    } else {
        Write-Output "This is an automated script scheduled to run at 7AM and 7PM (Mon-Fri) to start and stop VYED web applications. Please do not invoked it manually."
    }
}

# Get the status of the function app

$functionAppStatus = az functionapp show --name $functionAppName --resource-group $resourceGroupName --query "state" --output tsv
Write-Output "Current status of Azure Function App $functionAppName: $functionAppStatus"

if ($currentDay -eq 'Monday') {
    if ($currentHour -eq 7) {
        if ($functionAppStatus -eq "Stopped") {
            az functionapp start --name $functionAppName --resource-group $resourceGroupName
            Write-Output "Azure Function App $functionAppName started successfully."
        } else {
            Write-Output "Azure Function App $functionAppName is already running."
        }
    } else {
        Write-Output "Current time is not 7 AM on Monday. The function app status cannot be changed."
    }
} else {
    Write-Output "Today is not Monday. Function App status will not be changed. This script will automatically start the VYED function app at 7AM on Monday"
}
