param factoryName string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: factoryName
}

resource pipeline 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  parent: dataFactory
  name: 'TestCopyPipeline'
  properties: {
    activities: [
      {
        name: 'DataCopyActivity'
        type: 'Copy'
        typeProperties: {
          source: {
            type: 'BinarySource'
            storeSettings: {
              type: 'AzureBlobStorageReadSettings'
              recursive: true
            }
          }
          sink: {
            type: 'BinarySink'
            storeSettings: {
              type: 'AzureBlobStorageWriteSettings'
            }
          }
          enableStaging: false
        }
        inputs: [
          {
            referenceName: 'TestDatasetIn'
            type: 'DatasetReference'
          }
        ]
        outputs: [
          {
            referenceName: 'TestDatasetOut'
            type: 'DatasetReference'
          }
        ]
      }
    ]
  }
}