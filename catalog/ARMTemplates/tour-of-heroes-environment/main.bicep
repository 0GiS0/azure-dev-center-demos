@description('Name of the app')
param name string = ''

@description('Location to deploy the environment resources')
param location string = resourceGroup().location

var resourceName = !empty(name) ? replace(name, ' ', '-') : 'a${uniqueString(resourceGroup().id)}'

@description('Tags to apply to environment resources')
param tags object = {}

var hostingPlanName = '${resourceName}-hp'
var webAppName = '${resourceName}-web'
var sqlServerName = '${resourceName}-sql'

var sqlAdminLogin = 'dbadmin'
var sqlPassword = 'P@ssw0rd123'

// SQL Server
resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlPassword
    version: '12.0'
  }
  tags: tags
}

// App Service Plan
resource hostingPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: hostingPlanName
  location: location
  sku: {
    tier: 'Free'
    name: 'F1'
  }
  tags: tags
}

// Web App
resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: hostingPlan.id

    siteConfig: {
      connectionStrings: [
        {
          name: 'DefaultConnection'
          type: 'SQLAzure'  
          connectionString: 'Server=tcp:${sqlServerName}.database.windows.net,1433;Database=heroes;User ID=${sqlAdminLogin};Password=${sqlPassword};Encrypt=true;Connection Timeout=30;'
        }
      ]
      appSettings: []
    }
  }
  tags: tags
}

