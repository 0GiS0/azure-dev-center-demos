variable "location" {
  
}

variable "resource_group_name" {
  
}

variable "server_name" {
  
}

variable "administrator_login" {
  
}

variable "administrator_password" {
  
}
variable "database_name" {
  
}

variable "ade_subscription" {
  
}


provider "azurerm" {
  features {}
  
  subscription_id = var.ade_subscription
}

resource "random_pet" "server" {

}

resource "azurerm_resource_group" "rg" {

  name     = var.resource_group_name
  location = var.location

}

resource "azurerm_mssql_server" "sqlserver" {

  name                         = "${var.server_name}-${random_pet.server.id}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password

}

resource "azurerm_mssql_database" "db" {

  server_id = azurerm_mssql_server.sqlserver.id
  name      = var.database_name

  storage_account_type = "Local"

  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"

}
