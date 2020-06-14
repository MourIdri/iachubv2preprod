provider "azurerm" {
  version="2.0.0"
  features {}
  #subscription_id = "${var.azure-subscription-id}"
  #client_id       = "${var.azure-client-app-id}"
  #client_secret   = "${var.azure-client-secret-password}"
  #tenant_id       = "${var.azure-tenant-id}"
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
module "logging" {
  source               = "./modules/logging"
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"
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
  logacc_depend_on_module = [module.rg ]
}
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
  ip-range-module = "10.255.254.0/24"
  vnet_depend_on_module = [module.rg ]
}
# ROUTING & ADMIN PART :
module "subnet-nsg-privatedmzin" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/generic-subnet-nsg"
  root-name-subnet-module = "privatedmzin"
  iprange-subnet-module = "10.255.254.32/28"
  portrange-subnet-module =  ["21-4950"]
  subnet_depend_on_module = [module.network]
}
module "subnet-nsg-privatedmzoutlan" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/generic-subnet-nsg"
  root-name-subnet-module = "privatedmzoutlan"
  iprange-subnet-module = "10.255.254.48/28"
  portrange-subnet-module =  ["21-4950"]
  subnet_depend_on_module = [module.network]
}
module "mt-area-mgmt" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/vm-win-pri"
  subnet_in_id_module = "${module.subnet-nsg-privatedmzoutlan.subnet-iac-id}"
  ip-in-dcaddns-module = "10.255.254.53"
  dcaddns-size ="${var.vmsize_small_1_2}"
  dcaddns-login = "${var.genericusername}"
  dcaddns-passwd = "${var.genericpassword}"
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
  ip-in-nva-module = "10.255.254.36"
  ip-out-nva-module = "10.255.254.52"
  nva-size ="${var.vmsize_small_1_2}"
  nva-login = "${var.genericusername}"
  nva-passwd = "${var.genericpassword}"
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
  root-name-subnet-module = "mt"
  iprange-subnet-module = "10.255.254.16/28"
  portrange-subnet-module =  ["3389","443","22"]
  subnet_depend_on_module = [module.network]
}
module "mt-area-1" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/vm-win-pub"
  subnet_in_id_module = "${module.subnet-nsg-mt.subnet-iac-id}"
  ip-in-mt-module = "10.255.254.20"
  mt-size ="${var.vmsize_small_1_2}"
  mt-login = "${var.genericusername}"
  mt-passwd = "${var.genericpassword}"
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
  ip-in-mtl-module = "10.255.254.21"
  mtl-size ="${var.vmsize_small_1_2}"
  mtl-login = "${var.genericusername}"
  mtl-passwd = "${var.genericpassword}"
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
  root-name-subnet-module = "publicdmzin"
  iprange-subnet-module = "10.255.254.64/28"
  portrange-subnet-module =  ["443","80"]
  subnet_depend_on_module = [module.network]
}
module "waf-public-dmz" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"  
  source               = "./modules/waf-lnx"
  subnet_in_id_module = "${module.subnet-nsg-publicdmzin.subnet-iac-id}"
  ip-in-waf-module = "10.255.254.68"
  waf-size ="${var.vmsize_small_1_2}"
  waf-login = "${var.genericusername}"
  waf-passwd = "${var.genericpassword}"
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
}

#VPN PART 
module "subnet-nsg-vpn" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"    
  source               = "./modules/vpn-subnet-nsg"
  root-name-subnet-module = "GatewaySubnet"
  iprange-subnet-module = "10.255.254.0/28"
  portrange-subnet-module =  ["50","500","443","4500"]
  subnet_depend_on_module = [module.network]
}

module "vpn-standard-connect" {
  current-name-convention-core-public-module = "${var.current-name-convention-core-public-main}"
  current-name-convention-core-module  = "${var.current-name-convention-core-main}"
  preferred-location-module = "${var.preferred-location-main}"    
  source               = "./modules/vpn-onprem-cloud"
  iprange-onprem-module = ["10.0.1.96/28"]
  ipaddress-routeur-onprem-1-module = "40.89.184.82"
  subnet-vpn-target-id-module = "${module.subnet-nsg-vpn.subnet-iac-id}"
  corph-s2s-connection-pass = "${var.genericpassword}" 
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
