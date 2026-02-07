param synapseWorspaceName string
param rgLocation string = resourceGroup().location

param datalakeStorageUrl string
param datalakeStorageFilesystem string

param poolNames array = []

resource synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseWorspaceName
  location: rgLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      createManagedPrivateEndpoint: false
      accountUrl: datalakeStorageUrl
      filesystem: datalakeStorageFilesystem
    }
    encryption: {}
    privateEndpointConnections: []
    publicNetworkAccess: 'Enabled'
    azureADOnlyAuthentication: true
    trustedServiceBypassEnabled: false
  }
}

resource synapseWorkspacePools 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = [for poolName in poolNames: {
  parent: synapseWorkspace
  name: poolName
  location: rgLocation
  properties: {
    sparkVersion: '3.3'
    nodeCount: 10
    nodeSize: 'Medium'
    nodeSizeFamily: 'MemoryOptimized'
    autoScale: {
      enabled: true
      minNodeCount: 3
      maxNodeCount: 11
    }
    autoPause: {
      enabled: true
      delayInMinutes: 15
    }
    isComputeIsolationEnabled: false
    sessionLevelPackagesEnabled: true
    dynamicExecutorAllocation: {
      enabled: false
    }
    isAutotuneEnabled: false
    provisioningState: 'Succeeded'
  }
}]

resource synapseWorkspaceRuntimeIntegration 'Microsoft.Synapse/workspaces/integrationruntimes@2021-06-01' = {
  parent: synapseWorkspace
  name: 'AutoResolveIntegrationRuntime'
  properties: {
    type: 'Managed'
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
  }
}

resource firewallRule 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  name: 'allowAll'
  parent: synapseWorkspace
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

output appId string = synapseWorkspace.identity.principalId
