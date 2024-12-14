resource "azurerm_role_assignment" "current-user-kv-officer" {
  scope              = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id       = data.azurerm_client_config.current.object_id
}

# ---------------------- Dev Center ----------------
resource "azurerm_role_assignment" "dev-center-sig-contributor" {
  scope              = azurerm_shared_image_gallery.default.id
  role_definition_name = "Contributor"
  principal_id       = azurerm_user_assigned_identity.dev-center.principal_id
}

resource "azurerm_role_assignment" "dev-center-sub-contributor" {
  scope              = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id       = azurerm_user_assigned_identity.dev-center.principal_id
}

resource "azurerm_role_assignment" "dev-center-sub-user-access-admin" {
  scope              = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id       = azurerm_user_assigned_identity.dev-center.principal_id
}

# ---------------------- PACKER ----------------------
resource "azurerm_role_assignment" "packer_dev_center_rg_contributor" {
  description = "Allow Packer to view resources in the main Dev Center Resource Group (Used for Shared Compute Gallery)"
  role_definition_name = "Contributor"
  principal_type = "ServicePrincipal"
  principal_id = azuread_service_principal.packer.object_id
  scope = azurerm_resource_group.default.id
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

# ---------------------- Dev Center Project ----------------------

resource "azurerm_role_assignment" "dev-center-project-rg-contributor" {
  scope              = azurerm_resource_group.default.id
  role_definition_name = "Contributor"
  principal_id       = azurerm_user_assigned_identity.dev-center-project.principal_id
}

resource "azurerm_role_assignment" "dev-center-kv" {
  scope              = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Secrets User"
  principal_id       = azurerm_user_assigned_identity.dev-center-project.principal_id
}

resource "azurerm_role_assignment" "dev-center-project-accounting-dev-box-user" {
  scope                = azurerm_dev_center_project.accounting.id
  role_definition_name = "DevCenter Dev Box User"
  principal_id         = data.azurerm_client_config.current.object_id 
}

resource "azurerm_role_assignment" "dev-center-project-accounting-deployment-environments-user" {
  scope                = azurerm_dev_center_project.accounting.id
  role_definition_name = "Deployment Environments User"
  principal_id         = data.azurerm_client_config.current.object_id 
}

resource "azurerm_role_assignment" "dev-center-project-capital-markets-dev-box-user" {
  scope                = azurerm_dev_center_project.capital-markets.id
  role_definition_name = "DevCenter Dev Box User"
  principal_id         = data.azurerm_client_config.current.object_id 
}

resource "azurerm_role_assignment" "dev-center-project-capital-markets-deployment-environments-user" {
  scope                = azurerm_dev_center_project.capital-markets.id
  role_definition_name = "Deployment Environments User"
  principal_id         = data.azurerm_client_config.current.object_id 
}
