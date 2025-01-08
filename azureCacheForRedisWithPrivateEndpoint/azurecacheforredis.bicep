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
var redisPrivateEndpointName = 'myRedisPrivateEndpoint'
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

// resource redisPrivateEndpoint 'Microsoft.Cache/redis/privateEndpointConnections@2024-11-01' = {
//   parent: redisCache
//   name: redisPrivateEndpointName
//   properties: {
//     privateEndpoint: {}
//     privateLinkServiceConnectionState: {
//       status: 'Approved' 
//     }
//   }
// }
