targetScope = 'subscription'

@description('Name of the Resource Group to be created for ADF deployment')
param resourceGroupName string

@description('Name of the Data Factory instance')
param factoryName string

@description('Location for both the Resource Group and the Data Factory')
param location string

@description('Tags to be applied to both the Resource Group and Data Factory')
param tags object

@description('Managed Identity type for the Data Factory (SystemAssigned or None)')
@allowed([
  'SystemAssigned'
  'None'
])
param identityType string = 'SystemAssigned'

// Create the Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// Deploy Data Factory into the Resource Group via a module
module dataFactoryModule 'datafactory.bicep' = {
  name: 'deployDataFactory'
  scope: rg
  params: {
    factoryName: factoryName
    location: location
    identityType: identityType
    tags: tags
  }
}
