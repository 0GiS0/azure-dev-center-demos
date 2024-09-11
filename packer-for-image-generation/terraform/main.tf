resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a image gallery
resource "azurerm_shared_image_gallery" "gallery" {
  name                = var.packer_image_gallery_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  description         = "Packer Image Gallery"
}


# Create shared image definitions for each image
resource "azurerm_shared_image" "image_definitions" {
  for_each            = var.image_names
  name                = each.value
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  os_type = "Windows"

  trusted_launch_enabled = true
  hyper_v_generation     = "V2"

  identifier {
    publisher = "returngis"
    offer     = "${each.value}box"
    sku       = "1-0-0"
  }
}
