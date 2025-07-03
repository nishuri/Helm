param factoryName string
param location string
param identityType string = 'SystemAssigned'
param tags object

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: location
  identity: {
    type: identityType
  }
  tags: tags
  properties: {
    globalParameters: {}
  }
}
