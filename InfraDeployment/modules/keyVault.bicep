param keyvaultName string
param rgLocation string = resourceGroup().location
param acessAppIDs array
param tenantId string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyvaultName
  location: rgLocation
  properties: {
    accessPolicies: [for appId in acessAppIDs: {
      objectId: appId
      permissions: {
        certificates: [
          'Get'
          'List'
        ]
        keys: [
          'Get'
          'List'
        ]
        secrets: [
          'Get'
          'List'
        ]
      }
      tenantId: tenantId
    }]
    sku: {
      family: 'A'
      name: 'standard'
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    tenantId: subscription().tenantId
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: false
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}
