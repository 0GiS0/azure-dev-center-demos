# Disable in favor of using a GitHub App/OAuth instead of a PAT
# 
# resource "azurerm_dev_center_catalog" "default" {
#   name                = "default"
#   resource_group_name = azurerm_resource_group.default.name
#   dev_center_id       = azurerm_dev_center.default.id
#   catalog_github {
#     branch            = "main"
#     path              = "Environment-Definitions"
#     uri               = "https://github.com/microsoft/devcenter-catalog.git"
#     key_vault_key_url = azurerm_key_vault_secret.gh-pat.versionless_id
#   }
# }

resource "azurerm_dev_center_environment_type" "dev" {
  name          = "dev"
  dev_center_id = azurerm_dev_center.default.id

  tags = {
    Env = "dev"
  }
}

resource "azurerm_dev_center_environment_type" "test" {
  name          = "test"
  dev_center_id = azurerm_dev_center.default.id

  tags = {
    Env = "test"
  }
}

# Note that the name of the project environment must match an existing dev_center_environment_type name.  It can't be unique.
resource "azurerm_dev_center_project_environment_type" "accounting-dev" {
  name                  = azurerm_dev_center_environment_type.dev.name
  location              = azurerm_resource_group.default.location
  dev_center_project_id = azurerm_dev_center_project.accounting.id
  deployment_target_id  = "/subscriptions/${var.subscription_id}"

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.dev-center-project.id
    ]
  }
}

# Note that the name of the project environment must match an existing dev_center_environment_type name.  It can't be unique.
resource "azurerm_dev_center_project_environment_type" "accounting-test" {
  name                  = azurerm_dev_center_environment_type.test.name
  location              = azurerm_resource_group.default.location
  dev_center_project_id = azurerm_dev_center_project.accounting.id
  deployment_target_id  = "/subscriptions/${var.subscription_id}"

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.dev-center-project.id
    ]
  }
}