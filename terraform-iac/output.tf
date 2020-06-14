output "subscription_id" {
  value = "${data.azurerm_client_config.current.subscription_id}"
}
output "rg_name" {
  value = "${azurerm_resource_group.rg.name}"
}
output "rg_id" {
  value = "${azurerm_resource_group.rg.id}"
}
