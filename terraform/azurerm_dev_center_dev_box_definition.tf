resource "azurerm_dev_center_dev_box_definition" "default" {
  location           = azurerm_resource_group.default.location
  name               = "default-dcet"
  dev_center_id      = module.dev-center.id
  image_reference_id = data.azurerm_shared_image_version.custom_images["jetbrains"].id
  sku_name           = "demo"
}