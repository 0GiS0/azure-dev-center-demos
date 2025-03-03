resource "azurerm_dev_center_attached_network" "default" {
  name                  = "default-dev-center-attached-network"
  dev_center_id         = azurerm_dev_center.default.id
  network_connection_id = azurerm_dev_center_network_connection.default.id
}