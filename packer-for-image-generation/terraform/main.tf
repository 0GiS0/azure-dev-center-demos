resource azurerm_resource_group rg {
  name     = "packer-rg"
  location = var.location
}

# Create a image gallery
resource azurerm_shared_image_gallery gallery {
  name                = "packer_gallery"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  description         = "Packer Image Gallery"
}

# We need a shared image definition
resource azurerm_shared_image vscode {

  name                = "VSCodeWithPacker"
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  os_type = "Windows"  

  trusted_launch_enabled = true
  hyper_v_generation = "V2"

  identifier {
    publisher = "returngis"
    offer     = "vscodebox"
    sku       = "1-0-0"
  }
}
