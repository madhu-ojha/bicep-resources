  
//params for storage account
param parStorageAccountName string
param parLocation string = resourceGroup().location
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param parStorageAccountType string = 'Standard_LRS'


param parSubnetResourceId string

param parFunctionAppName string
param parApplicationInsightsName string
param parHostingPlanName string

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
    publicNetworkAccess: 'Enabled'
    allowBlobPublicAccess: false
    networkAcls: {
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: parSubnetResourceId
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
      ipRules: []
      defaultAction: 'Deny'
    }
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: parHostingPlanName
  location: parLocation
  sku: {
    name: 'FC1'
    tier: 'FlexConsumption'
  }
  properties: {}
}

resource functionApp 'Microsoft.Web/sites@2024-04-01' = {
  name:  parFunctionAppName
  location: parLocation
  kind: 'functionapp'
  properties: {
    serverFarmId: hostingPlan.id
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
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: parApplicationInsightsName
  location: parLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}
