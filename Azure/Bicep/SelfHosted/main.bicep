@description('Azure region')
param location string

@description('Virtual Machine name')
param vmName string

@description('VM size')
param vmSize string

@description('Admin username')
param adminUsername string

@secure()
@description('Admin password for Windows VM')
param adminPassword string

@description('Existing Virtual Network name')
param vnetName string

@description('Existing Subnet name')
param subnetName string

@description('CIDR allowed for RDP access')
param rdpAllowedCidr string

@description('OS disk storage SKU')
param osDiskSku string

@description('Windows image publisher')
param imagePublisher string

@description('Windows image offer')
param imageOffer string

@description('Windows image SKU')
param imageSku string

@description('Windows image version')
param imageVersion string



resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' existing = {
  name: subnetName
  parent: vnet
}


resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${vmName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: rdpAllowedCidr
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'Allow-Outbound-Internet'
        properties: {
          priority: 200
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRange: '*'
        }
      }
    ]
  }
}


resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    networkSecurityGroup: {
      id: nsg.id
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}


resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: imageVersion
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskSku
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
