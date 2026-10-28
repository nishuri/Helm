targetScope = 'resourceGroup'

param logicAppName string
param SubscriptionId string
param ResourceGroupName string
param ServerName string
param TenantId string
param ClientId string
@secure()
param ClientSecret string
param workflowState string = 'Enabled'
param scaleDownSkuName string = 'S1'

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
      ServerNameParam: {
        value: ServerName
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
      scaleDownSkuNameParam: {
        value: scaleDownSkuName
      }
    }
  }
}
