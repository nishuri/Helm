param factoryName string
param containerName string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: factoryName
}

resource dataFactoryDataSetIn 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'TestDatasetIn'
  properties: {
    linkedServiceName: {
      referenceName: 'TestStorageLinkedService'
      type: 'LinkedServiceReference'
    }
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        container: containerName
        folderPath: 'input'
        fileName: 'emp.txt'
      }
    }
  }
}

resource dataFactoryDataSetOut 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'TestDatasetOut'
  properties: {
    linkedServiceName: {
      referenceName: 'TestStorageLinkedService'
      type: 'LinkedServiceReference'
    }
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        container: containerName
        folderPath: 'output'
      }
    }
  }
}
