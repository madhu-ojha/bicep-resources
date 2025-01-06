param location string = resourceGroup().location
param myPrivateDNS string

resource symbolicname 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  location: 'global'
  name: myPrivateDNS
  properties: {}
}

