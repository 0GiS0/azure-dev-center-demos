resource "azurerm_dev_center" "default" {
  name                = "${var.resource_group.name}"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  identity {
    type = "UserAssigned"
    identity_ids = [
      var.identity.id
    ]
  }
}