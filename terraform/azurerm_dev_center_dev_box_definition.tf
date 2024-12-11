resource "azurerm_dev_center_dev_box_definition" "default" {
  for_each = var.custom_images
  location           = azurerm_resource_group.default.location
  name               = "${each.key}"
  dev_center_id      = module.dev-center.id
  image_reference_id = "${module.dev-center.gallery_id}/images/${azurerm_shared_image.image_definitions[each.key].name}"
  sku_name           = "general_i_8c32gb256ssd_v2" # The VM SKU to use for the Dev Box NOT the image SKU
}