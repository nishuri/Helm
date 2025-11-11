targetScope = 'resourceGroup'
param location string = resourceGroup().location
var tags = {
  'Account Code': 'Z00DS000A'
  'Analysis Code': '2431104'
  'Cost Centre': '10420751'
  Environment: 'Test'
  Owner: 'Fowler, Greg'
  'Parent Business': 'Business Intelligence'
  Portfolio: 'Education and Skills Funding Agency'
  Product: 'View Your Education Data'
  Service: 'Business Intelligence'
  'Service Line': 'Data Science (CEDD)'
  'Service Offering': 'View Your Education Data'
}
param vnetName string = 's148t01-vyed-vn-01'
param subnetName string = 's148t01-vyed-net8-01'
param subnetPrefix string = '10.0.3.0/29'
param aspName string = 's148t01-asp-net8-01'
param pubAppName string = 's148t01-as-pub-net8-01'
param adminAppName string = 's148t01-as-admin-net8-01'

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetPrefix
    delegations: [
      {
        name: 'appsvcDelegation'
        properties: {
          serviceName: 'Microsoft.Web/serverFarms'
        }
      }
    ]
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: aspName
  location: location
  tags: tags
  kind: 'app'
  sku: {
    name: 'B1'
    capacity: 1
  }
}

resource pubWebApplication 'Microsoft.Web/sites@2024-11-01' = {
  name: pubAppName
  location: location
  tags: tags
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: appServicePlan.id
    siteConfig: {
      netFrameworkVersion: 'v8.0'
      vnetRouteAllEnabled: false
      publicNetworkAccess: 'Enabled'
      ipSecurityRestrictionsDefaultAction: 'Deny'
      ipSecurityRestrictions: [
      {
        ipAddress: '208.127.45.99/32'
        action: 'Allow'
        tag: 'Default'
        priority: 100
        name: 'Rowan'
      }
      {
        ipAddress: '208.127.45.248/32'
        action: 'Allow'
        tag: 'Default'
        priority: 101
        name: 'Strawberry'
      }
      {
        ipAddress: '208.127.46.14/32'
        action: 'Allow'
        tag: 'Default'
        priority: 102
        name: 'Persimmon'
      }
      {
        ipAddress: '208.127.46.110/32'
        action: 'Allow'
        tag: 'Default'
        priority: 103
        name: 'Cacao'
      }
      {
        ipAddress: '208.127.50.230/32'
        action: 'Allow'
        tag: 'Default'
        priority: 104
        name: 'Osier'
      }
      {
        ipAddress: '208.127.52.236/32'
        action: 'Allow'
        tag: 'Default'
        priority: 105
        name: 'Mango'
      }
      {
        ipAddress: '208.127.52.237/32'
        action: 'Allow'
        tag: 'Default'
        priority: 106
        name: 'Olive'
      }
      {
        ipAddress: '208.127.53.148/32'
        action: 'Allow'
        tag: 'Default'
        priority: 107
        name: 'Peach'
      }
      {
        ipAddress: '208.127.46.232/29'
        action: 'Allow'
        tag: 'Default'
        priority: 108
        name: 'PRIMSA_Range_One'
      }
      {
        ipAddress: '208.127.46.240/28'
        action: 'Allow'
        tag: 'Default'
        priority: 109
        name: 'PRIMSA_Range_Two'
      }
      {
        ipAddress: 'AzureCloud'
        action: 'Allow'
        tag: 'ServiceTag'
        priority: 110
        name: 'AzureCloud Deployment'
      }
      {
        ipAddress: '52.166.34.242/32'
        action: 'Allow'
        tag: 'Default'
        priority: 113
        name: 'Allow Build server for testing'
      }
      {
        ipAddress: '20.26.15.238/32'
        action: 'Allow'
        tag: 'Default'
        priority: 112
        name: 'Azure-Virtual-Desktop'
      }
      {
        ipAddress: 'Any'
        action: 'Deny'
        priority: 2147483647
        name: 'Deny all'
        description: 'Deny all access'
      }]
    }
    clientAffinityEnabled: true
    clientCertMode: 'Required'
    httpsOnly: true
    virtualNetworkSubnetId: subnet.id
  }
}

resource adminWebApplication 'Microsoft.Web/sites@2024-11-01' = {
  name: adminAppName
  location: location
  tags: tags
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: appServicePlan.id
    siteConfig: {
      netFrameworkVersion: 'v8.0'
      vnetRouteAllEnabled: false
      publicNetworkAccess: 'Enabled'
      ipSecurityRestrictionsDefaultAction: 'Deny'
      ipSecurityRestrictions: [
      {
        ipAddress: '208.127.45.99/32'
        action: 'Allow'
        tag: 'Default'
        priority: 100
        name: 'Rowan'
      }
      {
        ipAddress: '208.127.45.248/32'
        action: 'Allow'
        tag: 'Default'
        priority: 101
        name: 'Strawberry'
      }
      {
        ipAddress: '208.127.46.14/32'
        action: 'Allow'
        tag: 'Default'
        priority: 102
        name: 'Persimmon'
      }
      {
        ipAddress: '208.127.46.110/32'
        action: 'Allow'
        tag: 'Default'
        priority: 103
        name: 'Cacao'
      }
      {
        ipAddress: '208.127.50.230/32'
        action: 'Allow'
        tag: 'Default'
        priority: 104
        name: 'Osier'
      }
      {
        ipAddress: '208.127.52.236/32'
        action: 'Allow'
        tag: 'Default'
        priority: 105
        name: 'Mango'
      }
      {
        ipAddress: '208.127.52.237/32'
        action: 'Allow'
        tag: 'Default'
        priority: 106
        name: 'Olive'
      }
      {
        ipAddress: '208.127.53.148/32'
        action: 'Allow'
        tag: 'Default'
        priority: 107
        name: 'Peach'
      }
      {
        ipAddress: '208.127.46.232/29'
        action: 'Allow'
        tag: 'Default'
        priority: 108
        name: 'PRIMSA_Range_One'
      }
      {
        ipAddress: '208.127.46.240/28'
        action: 'Allow'
        tag: 'Default'
        priority: 109
        name: 'PRIMSA_Range_Two'
      }
      {
        ipAddress: 'AzureCloud'
        action: 'Allow'
        tag: 'ServiceTag'
        priority: 110
        name: 'AzureCloud Deployment'
      }
      {
        ipAddress: '52.166.34.242/32'
        action: 'Allow'
        tag: 'Default'
        priority: 113
        name: 'Allow Build server for testing'
      }
      {
        ipAddress: '20.26.15.238/32'
        action: 'Allow'
        tag: 'Default'
        priority: 112
        name: 'Azure-Virtual-Desktop'
      }
      {
        ipAddress: 'Any'
        action: 'Deny'
        priority: 2147483647
        name: 'Deny all'
        description: 'Deny all access'
      }]
    }
    clientAffinityEnabled: true
    clientCertMode: 'Required'
    httpsOnly: true
    virtualNetworkSubnetId: subnet.id
  }
}