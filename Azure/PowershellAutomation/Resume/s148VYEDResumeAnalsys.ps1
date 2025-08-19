param(
    [Parameter(Mandatory = $true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$serverName
)


# Importing Analysis Service Modules
Write-Host "Getting PowerShell Module"
Import-Module Az.AnalysisServices


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

    if ($state -eq "Succeeded")
    {
        Write-Host "Azure Analysis Service server $serverName is running. State : $state. No Action Taken"
    }
    else
    {
        $resumeOut=Resume-AzAnalysisServicesServer -ResourceGroupName $resourceGroupName -Name $serverName -ErrorAction SilentlyContinue -ErrorVariable error

        if ($error)
        {
            Write-Host "Powershell command failed to resume Azure Analysis Service server $serverName. Error is $error"
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
                if ($currentState -eq "Succeeded")
                {
                    Write-Host "Azure Analysis Service server $serverName resumed Successfully. State is $currentState"
                }
                else
                {
                    Write-Host "Azure function failed to get the current state. Please review the Azure Analysis Service server $serverName"
                }
            }
        }
    }
}
