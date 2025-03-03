resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "packer" {
  name     = "${var.resource_group_name}-packer"
  location = var.location
}