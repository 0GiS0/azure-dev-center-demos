resource "azurerm_dev_center_project" "default" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  dev_center_id       = module.dev-center.id
  name                = "${module.dev-center.name}-project-1"
}