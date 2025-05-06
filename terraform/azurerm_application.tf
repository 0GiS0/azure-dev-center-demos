resource "azuread_application" "packer" {
  display_name = "Dev Center Packer SPN"
  owners = [data.azurerm_client_config.current.object_id]
}
resource "azuread_service_principal" "packer" {
  client_id = azuread_application.packer.client_id
  use_existing = true
  owners = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal_password" "packer" {
  service_principal_id = azuread_service_principal.packer.id
}