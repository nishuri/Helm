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
            Write-Output "Azure Web App $webAppName is already running."
        }
    } elseif ($currentHour -eq 19) {
        if ($webAppStatus -eq "Running") {
            az webapp stop --name $webAppName --resource-group $resourceGroupName
            Write-Output "Azure Web App $webAppName stopped successfully."
        } else {
            Write-Output "Azure Web App $webAppName is already stopped."
        }
    } else {
        Write-Output "Current time is not 7 AM or 7 PM. WebApp status will not be changed. It will automatically start or stop the webapp at 7AM and 7PM on Monday to Friday"
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
    } elseif ($currentHour -eq 19) {
        if ($functionAppStatus -eq "Running") {
            az functionapp stop --name $functionAppName --resource-group $resourceGroupName
            Write-Output "Azure Function App $functionAppName stopped successfully."
        } else {
            Write-Output "Azure Function App $functionAppName is already stopped."
        }
    } else {
        Write-Output "Current time is not 7 AM or 7 PM on Monday. The function app status cannot be changed."
    }
} else {
    Write-Output "Current status of Azure Function App $functionAppName: $functionAppStatus"
    Write-Output "Today is not Monday. Function App status will not be changed. It will automatically start or stop the function app at 7AM and 7PM on Monday"
}
