resource "azurerm_virtual_network" "default" {
  name = "dev-center-attached-vnet"
  location = var.location
  resource_group_name = azurerm_resource_group.default.name
  address_space = ["10.10.0.0/16"]
}

resource "azurerm_subnet" "dev-center" {
  name                 = "DevCenterAttachedSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.10.2.0/24"]
}