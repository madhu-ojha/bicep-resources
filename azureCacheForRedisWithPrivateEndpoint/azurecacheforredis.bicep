@description('Specify the name of the Azure Redis Cache to create.')
param redisCacheName string = 'myrediscachetest'

@description('Location of all resources')
param location string = resourceGroup().location

@description('Specify the pricing tier of the new Azure Redis Cache.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param redisCacheSKU string = 'Standard'
var redisPrivateEndpointName = 'myredisprivateendpoint'
var subnet1Name = 'firstSubnet'
var virtualNetworkName = 'myVnet'



resource redisCache 'Microsoft.Cache/redis@2024-11-01' = {
  name: redisCacheName
  location: location
  properties: {
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    sku: {
      name: redisCacheSKU
      capacity: 0
      family: 'C'
    }
  }
}
resource myVnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: virtualNetworkName
}

resource mySubnets 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
    parent: myVnet
    name: subnet1Name

}
resource redisPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: redisPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: mySubnets.id
    }
    privateLinkServiceConnections: [
      {
        name: '${redisCacheName}-privateLink'
        properties: {
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Private endpoint for Redis Cache'
          }
          privateLinkServiceId: redisCache.id
          groupIds: [
            'redisCache'
          ]
        }
      }  
    ]
  }
}

var privateDnsZoneName = 'privatelink.redis.cache.windows.net'
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
    name: privateDnsZoneName
    location: 'global'
}

resource privateDnsZoneVNetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
    name: '${privateDnsZone.name}/link'
    location: 'global'
    properties: {
        registrationEnabled: false
        virtualNetwork: {
            id: myVnet.id
        }
    }
}


var pvtEndpointDnsGroupName = '${redisPrivateEndpointName}/redisdnsgroup'
resource pvtEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  name: pvtEndpointDnsGroupName
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsGroupConfig'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
  dependsOn: [
    redisPrivateEndpoint
  ]
}
output redisCacheHostName string = redisCache.properties.hostName
output redisPrivateEndpointId string = redisPrivateEndpoint.id
