resource "azurerm_role_assignment" "current-user" {
  scope              = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id       = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "dev-center-kv" {
  scope              = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Secrets User"
  principal_id       = azurerm_user_assigned_identity.dev-center.principal_id
}

resource "azurerm_role_assignment" "dev-center-sig" {
  scope              = azurerm_shared_image_gallery.default.id
  role_definition_name = "Contributor"
  principal_id       = azurerm_user_assigned_identity.dev-center.principal_id
}

resource "azurerm_role_assignment" "packer_rg_contributor" {
  description = "Allow Packer to manage/deploy resources in the a specialized Packer build only Resource Group"
  role_definition_name = "Contributor"
  principal_type = "ServicePrincipal"
  principal_id = azuread_service_principal.packer.object_id
  scope = azurerm_resource_group.packer.id
}

resource "azurerm_role_assignment" "packer_sig_contributor" {
  description = "Allow Packer to manage Images in Shared Images Gallery"
  role_definition_name = "Contributor"
  principal_type = "ServicePrincipal"
  principal_id = azuread_service_principal.packer.object_id
  scope = azurerm_shared_image_gallery.default.id
}