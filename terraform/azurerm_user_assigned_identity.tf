resource "azurerm_user_assigned_identity" "dev-center" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  name                = "${azurerm_resource_group.default.name}-dev-center-user-msi"
}

resource "azurerm_user_assigned_identity" "dev-center-project" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  name                = "${azurerm_resource_group.default.name}-dev-center-project-user-msi"
}