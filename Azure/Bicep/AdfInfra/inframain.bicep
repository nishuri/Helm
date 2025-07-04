param location string = resourceGroup().location
param factoryName string
param storageAccountName string
param containerName string

module storage 'modules/storage.bicep' = {
  name: 'storageModule'
  params: {
    location: location
    storageAccountName: storageAccountName
    containerName: containerName
  }
}

module linkedService 'modules/linkedservices.bicep' = {
  name: 'linkedServiceModule'
  params: {
    factoryName: factoryName
    storageAccountName: storage.outputs.storageAccountName
  }
  dependsOn: [
    storage
  ]
}

module datasets 'modules/datasets.bicep' = {
  name: 'datasetsModule'
  params: {
    factoryName: factoryName
    containerName: containerName
  }
  dependsOn: [
    linkedService
  ]
}

module pipeline 'modules/pipeline.bicep' = {
  name: 'pipelineModule'
  params: {
    factoryName: factoryName
  }
  dependsOn: [
    datasets
  ]
}
