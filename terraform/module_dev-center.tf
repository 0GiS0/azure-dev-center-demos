# module "dev-center" {
#   source = "./modules/dev-center"
#   resource_group = azurerm_resource_group.default
#   identity = azurerm_user_assigned_identity.dev-center
#   shared_gallery_id = azurerm_shared_image_gallery.default.id
#   subnet-id = azurerm_subnet.dev-center.id
# }

# resource "azurerm_dev_center_dev_box_definition" "default" {
#   depends_on = [ terraform_data.packer ]
#   for_each = var.custom_images
#   location           = azurerm_resource_group.default.location
#   name               = "${each.key}"
#   dev_center_id      = module.dev-center.id
#   image_reference_id = "${module.dev-center.gallery_id}/images/${azurerm_shared_image.image_definitions[each.key].name}"
#   sku_name           = "general_i_8c32gb256ssd_v2" # The VM SKU to use for the Dev Box NOT the image SKU
# }

# resource "azurerm_dev_center_project" "default" {
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
#   dev_center_id       = module.dev-center.id
#   name                = "${module.dev-center.name}-project-1"
# }

# resource "azurerm_dev_center_project_pool" "default" {
#   for_each = azurerm_dev_center_dev_box_definition.default

#   name                                    = "${azurerm_dev_center_project.default.name}-${each.value.name}-pool"
#   location                                = azurerm_dev_center_project.default.location
#   dev_center_project_id                   = azurerm_dev_center_project.default.id
#   dev_box_definition_name                 = each.value.name
#   local_administrator_enabled             = true
#   dev_center_attached_network_name        = module.dev-center.attached_network_name
#   stop_on_disconnect_grace_period_minutes = 60
# }