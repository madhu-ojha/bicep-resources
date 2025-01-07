param location string = resourceGroup().location
var myStorageAccountName = 'demostorageaccount099'
var myContainerName = 'myfirstcontainer'
var virtualNetworkName = 'myVnet'
var subnet1Name = 'firstSubnet'
var privateEndpointName = 'myPrivateEndpoint'
param myPrivateDNS string = 'privatelink.blob.core.windows.net'

resource myPrivateDNSZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
    location: 'global'
    name: myPrivateDNS
    properties: {}
  }
  
resource myVnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource mySubnets 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
    parent: myVnet
    name: subnet1Name
    properties:{
        addressPrefix: '10.0.0.0/24'
    }
}
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
    name: privateEndpointName
    location: location 
    properties: {
      subnet: {
        id: mySubnets.id

      }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: myStorageAccount.id
          groupIds: ['blob']

        }
      }
  
    ]
    }
  }

  resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
    parent: myPrivateDNSZone
    name: '${myPrivateDNS}-link'
    location: 'global'
    properties: {
      registrationEnabled: false
      virtualNetwork: {
        id: myVnet.id
      }
    }
  }



resource myStorageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
    kind: 'BlobStorage'
    location: location
    name: myStorageAccountName
    properties: {
        accessTier: 'Hot'
        allowBlobPublicAccess: false
        dnsEndpointType: 'Standard'
        publicNetworkAccess: 'Disabled'
        
    }   
    sku: {
        name: 'Standard_LRS'
    }
}

resource myBlobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
    parent: myStorageAccount
    name: 'default'
}

resource myBlobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
    parent: myBlobService
    name: myContainerName
    properties: {
        publicAccess: 'None'
    }
}

