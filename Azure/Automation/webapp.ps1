param (
        [Parameter(Mandatory=$true)]
        [string]$subscriptionId,
        [Parameter(Mandatory=$true)]
        [string]$resourceGroupName,
        [Parameter(Mandatory=$true)]
        [string]$webAppName
    )

    # Setting your Azure subscription
    az account set --subscription $subscriptionId

    # Getting the status of the webapp
    $webAppStatus = az webapp show --name $webAppName --resource-group $resourceGroupName --query "state" --output tsv

    # Check the status of the webapp and start or stop the app accordingly
    if ($webAppStatus -eq "Running") {
        az webapp stop --name $webAppName --resource-group $resourceGroupName
        Write-Output "Azure Web App $webAppName stopped successfully."
    } elseif ($webAppStatus -eq "Stopped") {
        az webapp start --name $webAppName --resource-group $resourceGroupName
        Write-Output "Azure Web App $webAppName started successfully."
    } else {
        Write-Output "Azure Web App $webAppName is in an unknown state: $webAppStatus"
    }

# az functionapp show --name MyFunctionApp --resource-group MyResourceGroup
# az functionapp start --name MyFunctionApp --resource-group MyResourceGroup
# az functionapp stop --name MyFunctionApp --resource-group MyResourceGroup
