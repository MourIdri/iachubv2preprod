data "azurerm_client_config" "current" {}
output "current_client_id" {
  value = data.azurerm_client_config.current.client_id
}
output "current_tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
output "current_subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
output "current_object_id" {
  value = data.azurerm_client_config.current.object_id
}

module "rg" {
  source               = "./modules/rg"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"
  tags-rg-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="network"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"
  }
}
