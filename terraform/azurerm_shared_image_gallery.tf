resource "azurerm_shared_image_gallery" "default" {
  name                = "${azurerm_resource_group.default.name}sig"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

# Create shared image definitions for each image
resource "azurerm_shared_image" "image_definitions" {
  for_each            = var.custom_images
  name                = each.key
  gallery_name        = azurerm_shared_image_gallery.default.name
  resource_group_name = azurerm_resource_group.default.name
  location            = var.location

  os_type = "Windows"

  trusted_launch_enabled = true
  hyper_v_generation     = "V2"

  identifier {
    publisher = each.value.publisher_name
    offer     = each.value.offer_name
    sku       = each.value.sku
  }
}