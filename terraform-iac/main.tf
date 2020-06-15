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

#CI Validated so far 
module "logging" {
  source               = "./modules/logging"
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"
  current-az-sp-object-id-module = data.azurerm_client_config.current.object_id
  current-az-sp-tenant-id-module = data.azurerm_client_config.current.tenant_id
  current-vm-default-pass-module = "${var.current-vm-default-pass-main}"
  current-vm-default-username-module = "${var.current-vm-default-username-main}"
  tags-sto-logging-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="storage"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"}
  stoc_depend_on_module = [module.rg ]
  tags-repo-logging-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="logging"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"}
  logacc_depend_on_module = [module.rg]
}
#CI Validated so far 
module "network" {
  source               = "./modules/network"
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"
  tags-vnet-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="network"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"}
  ip-range-module = "${var.current-vnet-space}"
  vnet_depend_on_module = [module.rg]
}
#CI Validated so far 
# ROUTING & ADMIN PART :
module "subnet-nsg-privatedmzin" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/generic-subnet-nsg"
  #root-name-subnet-module = "privatedmzin"
  root-name-subnet-module = "${var.privatedmzin-root-name}"  
  #iprange-subnet-module = "10.255.254.32/28"
  iprange-subnet-module = "${var.subnet-privatedmzin}" 
  #portrange-subnet-module =  ["21-4950"]
  portrange-subnet-module =  ["${var.nsg-privatedmzin}"]
  subnet_depend_on_module = [module.network]
}
module "subnet-nsg-privatedmzoutlan" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/generic-subnet-nsg"
  #root-name-subnet-module = "privatedmzoutlan"
  root-name-subnet-module = "${var.privatedmzoutlan-root-name}"  
  #iprange-subnet-module = "10.255.254.48/28"
  iprange-subnet-module = "${var.subnet-privatedmzoutlan}"  
  #portrange-subnet-module =  ["21-4950"]
  portrange-subnet-module =  ["${var.nsg-privatedmzoutlan}"]  
  subnet_depend_on_module = [module.network]
}
