
@export()
type appConfiguration = {
  name: string
  createMode:  'Default' | 'Recover'
  authenticationMode: string
  privateLinkDelegation: 'Disabled' | 'Enabled'
  disableLocalAuth: bool
  publicNetworkAccess: 'Disabled' | 'Enabled'
  softDeleteRetentionDays: int
  skuName: string 
}
