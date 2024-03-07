// Variables
@description('Name of the web application')
param name string = ''

@description('Location to deploy the resources')
param location string = resourceGroup().location

var resourceName = !empty(name) ? replace(name, ' ', '-') : 'a${uniqueString(resourceGroup().id)}'

@description('Tag to apply to environment resources')
param tags object = {}

@description('The Runtime stack of current web app')
param linuxFxVersion string = 'DOTNETCORE|7.0'

var hostingPlanName = '${resourceName}-plan'
var webAppName = '${resourceName}-webapp'

@description('The SKU of the App Service Plan')
param sku string = 'F1'

// Resources
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: hostingPlanName
  location: location
  tags: tags
  sku: {
    name: sku

  }

  kind: 'linux'

  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
    }
  }
}
