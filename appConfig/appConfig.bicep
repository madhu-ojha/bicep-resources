param parAppConfigName string
param parCreateMode 'Default' | 'Recover'
param parAuthenticationMode string 
param parPrivateLinkDelegation  'Disabled' | 'Enabled'
param parDisableLocalAuth bool
param parPublicNetworkAccess 'Disabled' | 'Enabled'
param parSoftDeleteRetentionDays int
param parSkuName string 

resource resAppConfiguration 'Microsoft.AppConfiguration/configurationStores@2024-05-01' = {
  location: resourceGroup().location
  name: parAppConfigName
  properties: {
    createMode: parCreateMode
    dataPlaneProxy: {
      authenticationMode: parAuthenticationMode
      privateLinkDelegation: parPrivateLinkDelegation
    }
    disableLocalAuth: parDisableLocalAuth
    publicNetworkAccess: parPublicNetworkAccess
    softDeleteRetentionInDays:parSoftDeleteRetentionDays

  }
  sku: {
    name: parSkuName
  }
}
