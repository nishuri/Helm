param storageAccountName string
param location string
param containerName string

resource storageAccnt 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${storageAccnt.name}/default/${containerName}'
}

output storageAccountName string = storageAccnt.name
