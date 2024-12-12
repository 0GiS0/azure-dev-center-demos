resource "azurerm_dev_center" "default" {
  name                = azurerm_resource_group.default.name
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.dev-center.id
    ]
  }
}

resource "azurerm_dev_center_network_connection" "default" {
  name                = "default-dev-center-network-connection"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  domain_join_type    = "AzureADJoin"
  subnet_id           = azurerm_subnet.dev-center.id
}

resource "azurerm_dev_center_attached_network" "default" {
  name                  = "default-dev-center-attached-network"
  dev_center_id         = azurerm_dev_center.default.id
  network_connection_id = azurerm_dev_center_network_connection.default.id
}

resource "azurerm_dev_center_gallery" "default" {
  name              = "devcentergallery"
  dev_center_id     = azurerm_dev_center.default.id
  shared_gallery_id = azurerm_shared_image_gallery.default.id
}

resource "azurerm_dev_center_dev_box_definition" "default" {
  depends_on = [ terraform_data.packer ]
  for_each = var.custom_images
  location           = azurerm_resource_group.default.location
  name               = "${each.key}"
  dev_center_id      = azurerm_dev_center.default.id
  image_reference_id = "${azurerm_dev_center_gallery.default.id}/images/${azurerm_shared_image.image_definitions[each.key].name}"
  sku_name           = "general_i_8c32gb256ssd_v2" # The VM SKU to use for the Dev Box NOT the image SKU
}

resource "azurerm_dev_center_project" "default" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  dev_center_id       = azurerm_dev_center.default.id
  name                = "project1"
}

resource "azurerm_dev_center_project_pool" "default" {
  for_each = azurerm_dev_center_dev_box_definition.default

  name                                    = "${azurerm_dev_center_project.default.name}-${each.value.name}-pool"
  location                                = azurerm_dev_center_project.default.location
  dev_center_project_id                   = azurerm_dev_center_project.default.id
  dev_box_definition_name                 = each.value.name
  local_administrator_enabled             = true
  dev_center_attached_network_name        = azurerm_dev_center_attached_network.default.name
  stop_on_disconnect_grace_period_minutes = 60
}