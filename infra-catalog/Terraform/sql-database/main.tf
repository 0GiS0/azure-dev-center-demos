provider "azurerm" {
  features {}

  subscription_id = var.ade_subscription
}

variable "location" {
  default = "eastus"

}

variable "resource_group_name" {}

variable "server_name" {
  default = "${var.resource_name}-sqlserver"
}

variable "administrator_login" {

  default = "sqladmin"

}

variable "administrator_password" {

  default = "P@ssw0rd1234"

}
variable "database_name" {
  default = "${var.resource_name}-db"
}

variable "ade_subscription" {

}

resource "random_pet" "server" {

}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_mssql_server" "sqlserver" {

  name                         = "${var.server_name}-${random_pet.server.id}"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = data.azurerm_resource_group.rg.location
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
