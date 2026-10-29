targetScope = 'resourceGroup'

param logicAppName string
param SubscriptionId string
param ResourceGroupName string
param CapacityNames array
param TenantId string
param ClientId string
@secure()
param ClientSecret string
param workflowState string = 'Enabled'
param scaleDownSkuName string = 'A1'
param scaleDownSkuTier string = 'PBIE_Azure'

resource logicapp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: resourceGroup().location
  properties: {
    state: workflowState
    definition: loadJsonContent('workflow.json')
    parameters: {
      SubscriptionIdParam: {
        value: SubscriptionId
      }
      ResourceGroupNameParam: {
        value: ResourceGroupName
      }
      CapacityNamesParam: {
        value: CapacityNames
      }
      TenantIdParam: {
        value: TenantId
      }
      ClientIdParam: {
        value: ClientId
      }
      ClientSecretParam: {
        value: ClientSecret
      }
      scaleDownSkuTierParam: {
        value: scaleDownSkuTier
      }
      scaleDownSkuNameParam: {
        value: scaleDownSkuName
      }
    }
  }
}
