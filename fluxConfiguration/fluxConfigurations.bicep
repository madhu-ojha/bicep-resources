param parAksClusterName string
param parSubscriptionId string
param parResourceGroupName string

param parFluxConfigName string
param parHttpsUser string
param parProvider 'Azure' | 'Generic' | 'GitHub'

param parBranchName string
param parSourceUrl string
param parGitRepoSyncInterval int
param parGitRepoTimeout int

param parForceKustomization bool
param parKustomizationPath string
param parPruneKustomization bool
param parKustomizationSyncInterval int
param parKustomizationRetryInterval int
param parKustomizationTimeout int
param parKustomizationDependancies array 

param parFluxNamespace string
param parSourceKind 'AzureBlob' | 'Bucket' | 'GitRepository' | 'OCIRepository'
resource resAksCluster 'Microsoft.ContainerService/managedClusters@2025-02-01' existing = {
  name: parAksClusterName
  scope: resourceGroup(parSubscriptionId, parResourceGroupName)
}

resource fluxConfiguration 'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01' = {
  name: parFluxConfigName
  scope: resAksCluster
  properties: {
    scope: 'cluster'
    gitRepository: {
      httpsUser: parHttpsUser
      provider: parProvider
      repositoryRef: {
        branch: parBranchName
      }
      syncIntervalInSeconds: parGitRepoSyncInterval
      timeoutInSeconds: parGitRepoTimeout
      url: parSourceUrl
    }
    kustomizations: {
      kustomization: {
        dependsOn: parKustomizationDependancies
        force: parForceKustomization
        path: parKustomizationPath
        prune: parPruneKustomization
        retryIntervalInSeconds: parKustomizationRetryInterval
        syncIntervalInSeconds: parKustomizationSyncInterval
        timeoutInSeconds: parKustomizationTimeout
      }
    }
    namespace: parFluxNamespace
    sourceKind: parSourceKind    
  }
}
