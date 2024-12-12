resource "azurerm_dev_center_catalog" "default" {
  name                = "example"
  resource_group_name = azurerm_resource_group.default.name
  dev_center_id       = azurerm_dev_center.default.id
  catalog_github {
    branch            = "main"
    path              = "Environment-Definitions"
    uri               = "https://github.com/microsoft/devcenter-catalog.git"
    key_vault_key_url = azurerm_key_vault_secret.gh-pat.versionless_id
  }
}

resource "azurerm_dev_center_environment_type" "default" {
  name          = "demo"
  dev_center_id = azurerm_dev_center.default.id

  tags = {
    Env = "Test"
  }
}

# Note that the name of the project environment must match an existing dev_center_environment_type name.  It can't be unique.
resource "azurerm_dev_center_project_environment_type" "default" {
  name                  = azurerm_dev_center_environment_type.default.name
  location              = azurerm_resource_group.default.location
  dev_center_project_id = azurerm_dev_center_project.default.id
  deployment_target_id  = "/subscriptions/${var.subscription_id}"

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.dev-center-project.id
    ]
  }
}