targetScope = 'subscription'

@description('Name of the Resource Group to be created for ADF deployment')
param resourceGroupName string

@description('Name of the Data Factory instance')
param factoryName string

@description('Location for both the Resource Group and the Data Factory')
param location string

@description('Managed Identity type for the Data Factory (SystemAssigned or None)')
@allowed([
  'SystemAssigned'
  'None'
])
param identityType string = 'SystemAssigned'

// Create the Resource Group in the subscription.
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// Deploy the Data Factory resource into the newly created resource group.
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  scope: rg
  location: location
  identity: {
    type: identityType
  }
  properties: {
    globalParameters: {}
  }
}

