param(
    [Parameter(Mandatory = $true)]
    [string]$scaleInSku,

    [Parameter(Mandatory = $true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$serverName
)

# Importing Analysis Service Modules
Write-Host "Getting PowerShell Module"
Import-Module Az.AnalysisServices


#Getting Currnt State
$server=Get-AzAnalysisServicesServer -ResourceGroupName $resourceGroupName -Name $serverName -ErrorAction SilentlyContinue -ErrorVariable err

if ($err)
{
    Write-Host "Powershell command failed to GET the status of Azure Analysis Service server $server. Error $err"
}
else
{
    $state=$server.State
    $sku=$server.Sku.Name
    Write-Host "Azure Analysis Serice server $serverName is $state"

    if ($state -eq "Succeeded")
    {
        if ($sku -eq $scaleInSku)
        {
            Write-Host "Azure Analysis Service server $serverName is running on $sku pricing tier. State : $state. No Action Taken"
        }
        else
        {
            $scaleIn=Set-AzAnalysisServicesServer -Name $serverName -ResourceGroupName $resourceGroupName -Sku $scaleInSku -ErrorAction SilentlyContinue -ErrorVariable err

            if ($err)
            {
                Write-Host "Failed to Scale In Azure Analysis Service server $serverName. Error : $err"
            }
            else
            {
                $scaleInState=Get-AzAnalysisServicesServer -ResourceGroupName $resourceGroupName -Name $serverName -ErrorAction SilentlyContinue -ErrorVariable err

                if ($err)
                {
                    Write-Host "Powershell command failed to GET the status of Azure Analysis Service server $server. Error $err"
                }
                else
                {
                    $newState=$scaleInState.State
                    $newSku=$scaleInState.Sku.Name
                    Write-Host "Azure Analysis Server $serverName successfully scaled in to pricing tier $newSku. Current State : $newState and SKU : $newSku "
                }

            }

        }
    }
    else
    {
        if ($state -eq "Paused")
        {
            Write-Host "Azure Analysis Service server $serverName is $state. No Action Taken for Scale-In"
        }
        else
        {
            Write-Host "Current state of Azure Analysis Service server $serverName is UNKNOWN. No Action Taken. State : $state"
        }
    }
}
