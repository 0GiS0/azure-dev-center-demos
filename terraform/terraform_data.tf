resource "terraform_data" "packer" {
  depends_on = [ 
    azurerm_role_assignment.packer_rg_contributor,
    azurerm_role_assignment.packer_dev_center_rg_contributor,
    azurerm_role_assignment.packer_sig_contributor
  ]
  for_each = var.custom_images
  input = var.custom_images

  provisioner "local-exec" {
    working_dir = "${path.module}/../packer-for-image-generation/${each.key}"
    command = <<EOT
      packer init .
      
      packer build -force \
      -var client_id=${azuread_service_principal.packer.client_id} \
      -var client_secret=${azuread_service_principal_password.packer.value} \
      -var subscription_id=${var.subscription_id} \
      -var tenant_id=${data.azurerm_client_config.current.tenant_id} \
      -var location=${var.location} \
      -var build_resource_group_name=${azurerm_resource_group.packer.name} \
      -var resource_group=${azurerm_resource_group.default.name} \
      -var image_name=${each.key} \
      -var gallery_resource_group=${azurerm_resource_group.default.name} \
      -var gallery_name=${azurerm_shared_image_gallery.default.name} \
      -var image_version=${each.value.semver}  \
      .
    EOT
  }
}

data "azurerm_shared_image_version" "custom_images" {
  depends_on = [ terraform_data.packer ]
  for_each = var.custom_images
  image_name = each.key
  name = each.value.semver
  gallery_name = azurerm_shared_image_gallery.default.name
  resource_group_name = azurerm_resource_group.default.name
}