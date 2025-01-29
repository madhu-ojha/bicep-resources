  
//params for storage account
param parStorageAccountName string
param parLocation string = resourceGroup().location
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param parStorageAccountType string = 'Standard_LRS'


param parHostingPlanName string

param parFunctionAppName string

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

resource hosingPlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: parHostingPlanName
  location: parLocation
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource functionApp 'Microsoft.Web/sites@2024-04-01' = {
  name:  parFunctionAppName
  location: parLocation
  kind: 'functionapp'
  properties: {
    serverFarmId: hosingPlan.id
    functionAppConfig: {
      deployment: {
        storage: {
          type: 'blobContainer'
        }
      }
      runtime: {
        name: 'node'
        version: '20'
      }
      scaleAndConcurrency: {
        instanceMemoryMB: 2048
        maximumInstanceCount: 1
      }
    }
  }
}
