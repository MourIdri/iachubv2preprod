#VPNConfig
#Create Local Network Gateway
resource "azurerm_local_network_gateway" "onprem-corph-vpn-gw" {
  depends_on = [var.vpn_gw_depend_on]
  name                = "${var.current-name-convention-core-module}-localgw-corph"
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  location            = "${var.preferred-location-module}"
  gateway_address     = "${var.ipaddress-routeur-onprem-1-module}"
  address_space       = "${var.iprange-onprem-module}"
  tags = "${var.tags-onprem-1-standard-connect-module}"
   }
# Virtual Network Gateway
resource "azurerm_public_ip" "vpn-gw-pip" {
  depends_on = [var.vpn_gw_depend_on]
  name                = "${var.current-name-convention-core-module}-vpngw-corpcip"
  location            = "${var.preferred-location-module}"
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  domain_name_label            = "${var.current-name-convention-core-public-module}vpn1"
  allocation_method = "Dynamic"
  tags = "${var.tags-vpn-standard-connect-module}"
}
resource "azurerm_virtual_network_gateway" "vpn-gw" {
  depends_on = [azurerm_public_ip.vpn-gw-pip]
  name                = "${var.current-name-convention-core-module}-vpngw-corpc"
  location            = "${var.preferred-location-module}"
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  type     = "Vpn"
  vpn_type = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn-gw-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${var.subnet-vpn-target-id-module}"
  }
  tags = "${var.tags-vpn-standard-connect-module}"
}
# Virtual CREAT CONENCTION
resource "azurerm_virtual_network_gateway_connection" "vpn-gw-conx-1" {
  name                = "${var.current-name-convention-core-module}-conx-chcc1" 
  location            = "${var.preferred-location-module}"
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  type           = "IPsec"
  routing_weight = 1
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpn-gw.id
  local_network_gateway_id = azurerm_local_network_gateway.onprem-corph-vpn-gw.id
  shared_key = "${var.corph-s2s-connection-pass}"
  depends_on = [azurerm_virtual_network_gateway.vpn-gw,azurerm_local_network_gateway.onprem-corph-vpn-gw]
}
