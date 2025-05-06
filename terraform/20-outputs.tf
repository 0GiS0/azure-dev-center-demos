output client_id {
  value=   azuread_service_principal.packer.client_id
}
output client_secret {
  value=   azuread_service_principal_password.packer.value
  sensitive = true
}
output subscription_id {
  value=   var.subscription_id
}
output tenant_id {
  value=   data.azurerm_client_config.current.tenant_id
}
output location {
  value=   var.location
}
output build_resource_group_name {
  value=   azurerm_resource_group.packer.name
}
output resource_group {
  value=   azurerm_resource_group.default.name
}

output gallery_resource_group {
  value=   azurerm_resource_group.default.name
}
output gallery_name {
  value=   azurerm_shared_image_gallery.default.name
}  