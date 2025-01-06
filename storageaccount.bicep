param location string = resourceGroup().location
var myStorageAccountName = 'demostorageaccount099'
var myContainerName = 'myfirstcontainer'

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
