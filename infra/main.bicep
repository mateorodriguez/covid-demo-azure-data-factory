param location string = resourceGroup().location

@description('Specifies an environment-prefix for the resources names.')
param envPrefix string

@description('Specifies the overall solution name. Is used to ensure a naming standard among resources.')
param appName string

param envAppName string = '${envPrefix}-${appName}'
param envAppNameNorm string = '${envPrefix}${appName}'

//Create Keyvault and secret

@secure()
param secretValue string

@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
param secretsPermissions array = [
  'get'
  'list'
]

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: '${envAppName}-kv'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    publicNetworkAccess: 'enabled'
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    accessPolicies: [
      {
        objectId: DataFactory.identity.principalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: secretsPermissions
        }
      }
    ]
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  parent: keyVault
  name: 'DbServerPwd'
  properties: {
    value: secretValue
  }
}

// Storage Account Gen2

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${envAppNameNorm}strgacct'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    publicNetworkAccess: 'enabled'
    minimumTlsVersion: 'TLS1_2'
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: sa
  name: 'default'
}

// Storage Account Containers
resource configsContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: 'configs'
  properties: {}
}

resource populationContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServices
  name: 'population'
  properties: {}
}

// Storage Account Gen2

resource sadl 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${envAppNameNorm}dl'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    publicNetworkAccess: 'enabled'
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: true
  }
}

resource blobServicesDl 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: sadl
  name: 'default'
}

// Azure Data Lake Containers
resource lookupContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServicesDl
  name: 'lookup'
  properties: {}
}

resource processedContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServicesDl
  name: 'processed'
  properties: {}
}

resource rawContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobServicesDl
  name: 'raw'
  properties: {}
}


// Create Data Factory
resource DataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: '${envAppName}-adf'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess:'Enabled'
  }
}


// Create SQL server

@description('Specifies the name db server admin user name.')
param administratorLogin string

@description('Specifies the name db server admin login password.')
@secure()
param administratorLoginPassword string

resource dbServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: '${envAppName}-db-srv'
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
    version: '12.0'
  }
}

resource symbolicname 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  name: '${envAppName}-db'
  location: location
  sku: {
    capacity: 1
    family: 'Gen5'
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
  }
  parent: dbServer
  properties: {
    autoPauseDelay: 60
    availabilityZone: 'NoPreference'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    isLedgerOn: false
    maxSizeBytes: 1073741824
    minCapacity: json('0.5')
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Local'
    zoneRedundant: false
  }
}
