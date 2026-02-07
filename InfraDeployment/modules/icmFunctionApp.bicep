param functionAppName string
param appInsightsKey string
param storageAccountConnectionString string

param rgLocation string = resourceGroup().location
param planSku string = 'Y1'
param planTier string = 'Dynamic'

resource serverFarm 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: '${functionAppName}svrfrm'
  location: rgLocation
  sku: {
    name: planSku
    tier: planTier
  }
}

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: functionAppName
  identity: {
    type: 'SystemAssigned'
  }
  location: rgLocation
  kind: 'functionapp'
  properties: {
    serverFarmId: serverFarm.id
    httpsOnly: true
    siteConfig: {
      use32BitWorkerProcess: false
    }
  }
}

resource functionAppAppsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: 'appsettings'
  parent: functionApp
  properties: {
    AzureWebJobsStorage: storageAccountConnectionString
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: storageAccountConnectionString
    WEBSITE_CONTENTSHARE: toLower(functionAppName)
    FUNCTIONS_EXTENSION_VERSION: '~4'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    FUNCTIONS_WORKER_RUNTIME: 'dotnet'
  }
}

output appId string = functionApp.identity.principalId
