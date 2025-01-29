  
//params for storage account
param parStorageAccountName string
param parLocation string = resourceGroup().location
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param parStorageAccountType string = 'Standard_LRS'

//storage account needed for app function
resource storageAccountForFunction 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: parStorageAccountName
  location: parLocation
  sku:{
    name: parStorageAccountType
  }
  kind: 'Storage'
  properties: {
    supportsHttpsTrafficOnly: true
    defaultToOAuthAuthentication: true
  }
}
