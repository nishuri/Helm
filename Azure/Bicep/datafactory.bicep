@description('Name of the Data Factory instance')
param factoryName string

@description('Location for the Data Factory')
param location string = resourceGroup().location

@description('Managed Identity type for the Data Factory (SystemAssigned or None)')
@allowed([
  'SystemAssigned'
  'None'
])
param identityType string = 'SystemAssigned'

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: location
  identity: {
    type: identityType
  }
  properties: {
    globalParameters: {}
  }
}
