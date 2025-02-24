resource "azurerm_dev_center_network_connection" "default" {
  name                = "default-dev-center-network-connection"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  domain_join_type    = "AzureADJoin"
  subnet_id           = var.subnet-id
}