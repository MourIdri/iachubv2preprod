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
module "mt-area-mgmt" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/vm-win-pri"
  subnet_in_id_module = "${module.subnet-nsg-privatedmzoutlan.subnet-iac-id}"
  #ip-in-dcaddns-module = "10.255.255.53"
  ip-in-dcaddns-module = "${var.mt-area-dc-dns-private-ip-address}" 
  dcaddns-size ="${var.vmsize_small_1_2}"
  dcaddns-login = "${var.current-vm-default-username-main}"
  dcaddns-passwd = "${var.current-vm-default-pass-main}"
  stor-log-repo = "${module.logging.hub-corpc-sto-acc-log-endpoint}"
  stor-log-ws-crd-1 = "${module.logging.hub-corpc-log-ana-rep-primary-workspace-id}"
  stor-log-ws-crd-2 = "${module.logging.hub-corpc-log-ana-rep-primary-key}"
  dcaddns_depend_on = [module.subnet-nsg-privatedmzoutlan]
  tags-dcaddns-win-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="domain_identity"
    type_2="ad_dc_dns"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"
  }
}

module "security-appliance-dmz" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/security-appliance-lnx"
  subnet_in_id_module = "${module.subnet-nsg-privatedmzin.subnet-iac-id}"
  subnet_out_id_module = "${module.subnet-nsg-privatedmzoutlan.subnet-iac-id}"
  #ip-in-nva-module = "10.255.255.36"
  ip-in-nva-module = "${var.security-appliance-dmz-private-ip-address-in}" 
  #ip-out-nva-module = "10.255.255.52"
  ip-out-nva-module = "${var.security-appliance-dmz-private-ip-address-out}" 
  nva-size ="${var.vmsize_small_1_2}"
  nva-login = "${var.current-vm-default-username-main}"
  nva-passwd = "${var.current-vm-default-pass-main}"
  stor-log-repo = "${module.logging.hub-corpc-sto-acc-log-endpoint}"
  stor-log-repo-name = "${module.logging.hub-corpc-sto-acc-log-name}"
  stor-log-repo-sas = "${module.logging.hub-corpc-sto-acc-log-sas-url-string}"
  ev-hb-log-id = "${module.logging.hub-corpc-ev-hb-1-id}" 
  ev-hb-log-pri-conx-string = "${module.logging.hub-corpc-ev-hb-1-pri-conx-string}" 
  ev-hb-log-pri-conx-key = "${module.logging.hub-corpc-ev-hb-1-pri-conx-key}" 
  stor-log-ws-crd-1 = "${module.logging.hub-corpc-log-ana-rep-primary-workspace-id}"
  stor-log-ws-crd-2 = "${module.logging.hub-corpc-log-ana-rep-primary-key}"  
  security_appliance_depend_on = [module.subnet-nsg-privatedmzoutlan,module.subnet-nsg-privatedmzin]
  tags-security-appliance-dmz-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="router"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"
  }
}
#MANAGEMENT PART 
module "subnet-nsg-mt" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/generic-subnet-nsg"
  #root-name-subnet-module = "mt"
  root-name-subnet-module = "${var.mt-root-name}"  
  iprange-subnet-module = "${var.subnet-mt}"  
  #iprange-subnet-module = "10.255.255.16/28"
  #portrange-subnet-module =  ["3389","443","22","80"]
  portrange-subnet-module =  ["${var.nsg-mt-1}","${var.nsg-mt-2}","${var.nsg-mt-3}"] 
  subnet_depend_on_module = [module.network]
}
module "mt-area-1" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/vm-win-pub"
  subnet_in_id_module = "${module.subnet-nsg-mt.subnet-iac-id}"
  #ip-in-mt-module = "10.255.255.20"
  ip-in-mt-module = "${var.mt-vm-private-ip-address}" 
  mt-size ="${var.vmsize_small_1_2}"
  mt-login = "${var.current-vm-default-username-main}"
  mt-passwd = "${var.current-vm-default-pass-main}"
  stor-log-repo = "${module.logging.hub-corpc-sto-acc-log-endpoint}"
  mt_depend_on = [module.subnet-nsg-mt]
  stor-log-ws-crd-1 = "${module.logging.hub-corpc-log-ana-rep-primary-workspace-id}"
  stor-log-ws-crd-2 = "${module.logging.hub-corpc-log-ana-rep-primary-key}"
  tags-mt-win-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="jumphost"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"
  }
}
module "mtl-area-1" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/vm-lnx-pri"
  subnet_in_id_module = "${module.subnet-nsg-mt.subnet-iac-id}"
  #ip-in-mtl-module = "10.255.255.21"
  ip-in-mtl-module = "${var.mtl-vm-private-ip-address}" 
  mtl-size ="${var.vmsize_small_1_2}"
  mtl-login = "${var.current-vm-default-username-main}"
  mtl-passwd = "${var.current-vm-default-pass-main}"
  stor-log-repo = "${module.logging.hub-corpc-sto-acc-log-endpoint}"
  stor-log-repo-name = "${module.logging.hub-corpc-sto-acc-log-name}"
  stor-log-repo-sas = "${module.logging.hub-corpc-sto-acc-log-sas-url-string}"
  stor-log-ws-crd-1 = "${module.logging.hub-corpc-log-ana-rep-primary-workspace-id}"
  stor-log-ws-crd-2 = "${module.logging.hub-corpc-log-ana-rep-primary-key}"  
  mtl_depend_on = [module.subnet-nsg-mt]
  tags-mtl-lnx-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="adminlnx"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"
  }
}
#WEB PART 
module "subnet-nsg-publicdmzin" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/generic-subnet-nsg"
  #root-name-subnet-module = "publicdmzin"
  root-name-subnet-module = "${var.publicdmzin-root-name}"  
  #iprange-subnet-module = "10.255.255.64/28"
  iprange-subnet-module = "${var.subnet-publicdmzin}"  
  #portrange-subnet-module =  ["443","80"]
  portrange-subnet-module =  ["${var.nsg-publicdmzin-1}","${var.nsg-publicdmzin-2}"]
  subnet_depend_on_module = [module.network]
}
module "waf-public-dmz" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/waf-lnx"
  subnet_in_id_module = "${module.subnet-nsg-publicdmzin.subnet-iac-id}"
  #ip-in-waf-module = "10.255.254.68"
  ip-in-waf-module = "${var.waf-vm-private-ip-address}" 
  waf-size ="${var.vmsize_small_1_2}"
  waf-login = "${var.current-vm-default-username-main}"
  waf-passwd = "${var.current-vm-default-pass-main}"
  stor-log-repo = "${module.logging.hub-corpc-sto-acc-log-endpoint}"
  stor-log-repo-name = "${module.logging.hub-corpc-sto-acc-log-name}"
  stor-log-repo-sas = "${module.logging.hub-corpc-sto-acc-log-sas-url-string}"
  stor-log-ws-crd-1 = "${module.logging.hub-corpc-log-ana-rep-primary-workspace-id}"
  stor-log-ws-crd-2 = "${module.logging.hub-corpc-log-ana-rep-primary-key}"  
  waf_depend_on = [module.subnet-nsg-privatedmzoutlan]
  tags-waf-public-dmz-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="waf"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"
  }

#VPN PART 
module "subnet-nsg-vpn" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"    
  source               = "./modules/vpn-subnet-nsg"
  #root-name-subnet-module = "GatewaySubnet"
  root-name-subnet-module = "${var.GatewaySubnet-root-name}"  
  #iprange-subnet-module = "10.255.254.0/28"
  iprange-subnet-module = "${var.subnet-GatewaySubnet}"  
  #portrange-subnet-module =  ["50","500","443","4500"]
  portrange-subnet-module =   ["${var.nsg-GatewaySubnet-1}","${var.nsg-GatewaySubnet-2}","${var.nsg-GatewaySubnet-3}","${var.nsg-GatewaySubnet-4}"]
  subnet_depend_on_module = [module.network]
}

module "vpn-standard-connect" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"    
  source               = "./modules/vpn-onprem-cloud"
  #iprange-onprem-module = ["10.0.1.96/28"]
  iprange-onprem-module = ["${var.iprange-onprem-vpn}"]
  #ipaddress-routeur-onprem-1-module = "40.89.184.82"
  ipaddress-routeur-onprem-1-module = "${var.ipaddress-routeur-onprem-1-azuredevops}"
  subnet-vpn-target-id-module = "${module.subnet-nsg-vpn.subnet-iac-id}"
  corph-s2s-connection-pass = "${var.current-vm-default-pass-main}"
  vpn_gw_depend_on = [module.subnet-nsg-vpn]
  tags-vpn-standard-connect-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="vpn"
    lob="it_infrastructure"
    business_location="corpc"
    projectowner="it_transverse_cloud_team"
  }
  tags-onprem-1-standard-connect-module = {
    environment = "production"
    scope_1="shared_infrastructure"
    scope_2="core_infrastructure"
    type_1="network_security"
    type_2="router"
    lob="it_infrastructure"
    business_location="corph"
    projectowner="it_transverse_cloud_team"
  }
}