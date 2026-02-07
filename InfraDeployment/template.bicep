param rgLocation string = resourceGroup().location

param keyVaultname string
param storageAccountName string
param logAnalyticsName string
param synapseWorkspaceName string
param datalakeStorageFilesystem string
param appInsightsName string
param icmFunctionName string
param tenantId string

module keyvault 'modules/keyVault.bicep' = {
  name: keyVaultname
  params: {
    acessAppIDs: [ synapseWorkspace.outputs.appId, icmFunction.outputs.appId ]
    tenantId: tenantId
    keyvaultName: keyVaultname
    rgLocation: rgLocation
  }
}

module storageAccount 'modules/storage.bicep' = {
  name: storageAccountName
  params: {
    storageAccountName: storageAccountName
    rgLocation: rgLocation
    containerList: [
      'cartier'
    ]
    tableList: [
      'ApiCallHistoryLog'
      'ApiDataLocation'
      'ApiMetaData'
      'HRDLDeltaFileQueue'
      'HRDLFilePublishDetails'
      'PayCodeMetadata'
      'HRDLCleanUpRecords'
    ]
  }
}

module logAnalytics 'modules/logAnalytics.bicep' = {
  name: logAnalyticsName
  params: {
    logAnalyticsName: logAnalyticsName
    rgLocation: rgLocation
  }
}

module synapseWorkspace 'modules/synapse.bicep' = {
  name: synapseWorkspaceName
  params: {
    synapseWorspaceName: synapseWorkspaceName
    rgLocation: rgLocation
    datalakeStorageUrl: 'https://${storageAccountName}.dfs.core.windows.net'
    datalakeStorageFilesystem: datalakeStorageFilesystem
    poolNames: [
      'cartierpool'
    ]
  }
}

module appInsights 'modules/appInsights.bicep' = {
  name: appInsightsName
  params: {
    appInsightsName: appInsightsName
    rgLocation: rgLocation
    logAnalyticsId: logAnalytics.outputs.logAnalyticsId
  }
}

module icmFunction 'modules/icmFunctionApp.bicep' = {
  name: icmFunctionName
  params: {
    functionAppName: icmFunctionName
    rgLocation: rgLocation
    appInsightsKey: appInsights.outputs.appInsightsKey
    storageAccountConnectionString: storageAccount.outputs.storageAccountConnectionString
  }
}
