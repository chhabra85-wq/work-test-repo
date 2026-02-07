targetScope = 'subscription'

@description('Azure region of resource deployment.')
param azRegion string

@description('Azure resource group name.')
param resourceGroupName string

@description('App Insights name.')
param appInsightsName string = 'cartierAI'

param datalakeStorageFilesystem string = 'cartier'
param keyVaultname string = 'Time-Cartier-KV'
param logAnalyticsName string = 'log-analytics-cartier'
param storageAccountName string = 'strcartier'
param synapseWorkspaceName string = 'synw-time-cartier'
param icmFunctionName string = 'cartier-icm-functions'

param tenantId string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: azRegion
}

module resources 'template.bicep' = {
  name: 'DeployedResources'
  scope: resourceGroup
  params: {
    tenantId: tenantId
    icmFunctionName: icmFunctionName
    rgLocation: resourceGroup.location
    appInsightsName: appInsightsName
    datalakeStorageFilesystem: datalakeStorageFilesystem
    keyVaultname: keyVaultname
    logAnalyticsName: logAnalyticsName
    storageAccountName: storageAccountName
    synapseWorkspaceName: synapseWorkspaceName
  }
}
