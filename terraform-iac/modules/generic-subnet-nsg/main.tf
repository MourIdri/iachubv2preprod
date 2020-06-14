#create subnet 
resource "azurerm_subnet" "subnet-iac" {
  name                = "${var.current-name-convention-core-module}-subnet-${var.root-name-subnet-module}"
  resource_group_name  = "${var.current-name-convention-core-module}-rg"
  virtual_network_name = "${var.current-name-convention-core-module}-vnet"
  address_prefix       = "${var.iprange-subnet-module}"
  depends_on = [var.subnet_depend_on_module]
  
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg-iac" {
    depends_on = [var.subnet_depend_on_module]
    name                = "${var.current-name-convention-core-module}-subnet-${var.root-name-subnet-module}-nsg"
    location            = "${var.preferred-location-module}" 
    resource_group_name = "${var.current-name-convention-core-module}-rg"
    security_rule {
        name                       = "nsgruleallowdefault"
        priority                   = 4001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_ranges     = "${var.portrange-subnet-module}" 
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}
resource "azurerm_subnet_network_security_group_association" "subnet-nsg-assoc-iac" {
  subnet_id                 = azurerm_subnet.subnet-iac.id
  network_security_group_id = azurerm_network_security_group.nsg-iac.id
}
output "durty-temp-outupt0" {
  value = "${var.preferred-location-module}" 
}
output "durty-temp-outupt1" {
  value ="${var.current-name-convention-core-public-module}"  
}