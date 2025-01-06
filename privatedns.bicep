param location string = resourceGroup().location
param myPrivateDNS string

resource symbolicname 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  location: location
  name: myPrivateDNS
  properties: {}
}
