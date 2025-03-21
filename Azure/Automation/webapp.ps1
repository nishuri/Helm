param (
        [Parameter(Mandatory=$true)]
        [string]$subscriptionId,
        [Parameter(Mandatory=$true)]
        [string]$resourceGroupName,
        [Parameter(Mandatory=$true)]
        [string[]]$webAppNames
        [Parameter(Mandatory=$true)]
        [string]$functionAppName
    )

    # Setting your Azure subscription
    az account set --subscription $subscriptionId

    foreach ($webAppName in $webAppNames) {
    # Get the status of the web app
    $webAppStatus = az webapp show --name $webAppName --resource-group $resourceGroupName --query "state" --output tsv

    # Check the status and start or stop the web app accordingly
    if ($webAppStatus -eq "Running") {
        az webapp stop --name $webAppName --resource-group $resourceGroupName
        Write-Output "Azure Web App $webAppName stopped successfully."
    } elseif ($webAppStatus -eq "Stopped") {
        az webapp start --name $webAppName --resource-group $resourceGroupName
        Write-Output "Azure Web App $webAppName started successfully."
    } else {
        Write-Output "Azure Web App $webAppName is in an unknown state: $webAppStatus"
    }
}

# Get the status of the function app

$functionAppStatus = az functionapp show --name $functionAppName --resource-group $resourceGroupName --query "state" --output tsv

# Check the status and start the function app if necessary
if ($functionAppStatus -eq "Stopped") {
    az functionapp start --name $functionAppName --resource-group $resourceGroupName
    Write-Output "Azure Function App $functionAppName started successfully."
} elseif ($functionAppStatus -eq "Running") {
    Write-Output "Azure Function App $functionAppName is already running."
} else {
    Write-Output "Azure Function App $functionAppName is in an unknown state: $functionAppStatus"
}
