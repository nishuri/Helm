# Set the properties for the Azure Analysis Services instance
$subscriptionId = '89bc3160-da6b-4145-b11d-e364986037a3'
$resourceGroupName = 's148d01-aas-anm'
$serverName = 's148d01aasanm01'

# Write an information log with the current time.
Write-Host "Running Powershell code to Suspend Azure Analysis Service $serverName"

#Getting Currnt State
$server=Get-AzAnalysisServicesServer -ResourceGroupName $resourceGroupName -Name $serverName -ErrorAction SilentlyContinue -ErrorVariable error

if ($error)
{
    Write-Host "Powershell command failed to GET the status of Azure Analysis Service server $server. Error $error"
}
else
{
    $state=$server.State
    Write-Host "Azure Analysis Serice server $serverName is $state"

    if ($state -eq "Paused")
    {
        Write-Host "Azure Analysis Service server $serverName is Stopped. State : $state. No Action Taken"
    }
    else
    {
        $suspendOut=Suspend-AzAnalysisServicesServer -ResourceGroupName $resourceGroupName -Name $serverName -ErrorAction SilentlyContinue -ErrorVariable error

        if ($error)
        {
            Write-Host "Powershell command failed to suspend Azure Analysis Service server $serverName. Error is $error"
        }
        else
        {
            $newState=Get-AzAnalysisServicesServer -ResourceGroupName $resourceGroupName -Name $serverName -ErrorAction SilentlyContinue -ErrorVariable error
            if ($error)
            {
                Write-Host "Powershell command failed to GET the status of Azure Analysis Service server $serverName. Error : $error"
            }
            else
            {
                $currentState=$newState.State
                if ($currentState -eq "Paused")
                {
                    Write-Host "Azure Analysis Service server $serverName stopped Successfully. State is $currentState"
                }
                else
                {
                    Write-Host "Azure function failed to get the current state. Please review Azure Analysis Service server $serverName"
                }
            }
        }
    }
}
