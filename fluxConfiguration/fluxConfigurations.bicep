import * as types from 'fluxConfiguration.types.bicep'

param parAksClusterName string
// param parSubscriptionId string
// param parResourceGroupName string

param parFluxConfigName string
param parFluxConfigScope 'cluster' | 'namespace' = 'cluster'

param parGithubUser string
param parGithubPat string
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
param parSubstituteFrom types.substituteFrom
param parKustomizationProps types.kustomizationProps

param parKustomizations object = {
  kustomization: parKustomizationProps
}

param parFluxNamespace string
param parSourceKind 'AzureBlob' | 'Bucket' | 'GitRepository' | 'OCIRepository'
resource resAksCluster 'Microsoft.ContainerService/managedClusters@2025-02-01' existing = {
  name: parAksClusterName
  // scope: resourceGroup(parSubscriptionId, parResourceGroupName)
}

resource fluxConfiguration 'Microsoft.KubernetesConfiguration/fluxConfigurations@2024-11-01' = {
  name: parFluxConfigName
  scope: resAksCluster
  properties: {
    scope: parFluxConfigScope
    gitRepository: {
      repositoryRef: {
        branch: parBranchName
      }
      localAuthRef: '${parFluxConfigName}-protected-parameters'
      syncIntervalInSeconds: parGitRepoSyncInterval
      timeoutInSeconds: parGitRepoTimeout
      url: parSourceUrl
    }
    configurationProtectedSettings: {
      username: base64(parGithubUser)
      password: base64(parGithubPat)
    }
    // kustomizations: parKustomizations
    kustomizations: {
      kustomization1: {
        dependsOn: parKustomizationDependancies
        force: parForceKustomization
        path: parKustomizationPath
        prune: parPruneKustomization
        retryIntervalInSeconds: parKustomizationRetryInterval
        syncIntervalInSeconds: parKustomizationSyncInterval
        timeoutInSeconds: parKustomizationTimeout
        postBuild: {
          substituteFrom: [
            {
              kind: parSubstituteFrom.kind
              name: parSubstituteFrom.name
            }
          ]
        }
      }
    }
    namespace: parFluxNamespace
    sourceKind: parSourceKind
  }
}
