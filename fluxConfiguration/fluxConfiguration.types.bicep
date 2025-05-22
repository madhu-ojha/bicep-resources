@export()
type substituteFrom = {
  kind: string
  name: string
  optional: bool?
}

@export()
type kustomizationProps = {
  dependsOn: array
  force: bool?
  path: string
  prune: bool?
  retryIntervalInSeconds: int?
  syncIntervalInSeconds: int?
  timeoutInSeconds: int?
  postBuild: {
    substituteFrom: {
      kind: string
      name: string
      optional: bool?
    }[]
  }
}

@export()
type kustomizations = {
  *: kustomizationProps
}
