param appInsightsName string
param logAnalyticsId string
param rgLocation string = resourceGroup().location

resource appInsights 'microsoft.insights/components@2020-02-02' = {
  name: appInsightsName
  location: rgLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtension'
    RetentionInDays: 90
    WorkspaceResourceId: logAnalyticsId
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output appInsightsKey string = reference(appInsights.id, '2014-04-01').InstrumentationKey
