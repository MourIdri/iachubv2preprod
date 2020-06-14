# Create public IPs
resource "azurerm_public_ip" "mt-nic-puip" {
    depends_on = [var.mt_depend_on]
    name                         = "${var.current-name-convention-core-module}-mtwin-nicinpuip"
    location                     = "${var.preferred-location-module}" 
    resource_group_name          = "${var.current-name-convention-core-module}-rg"
    domain_name_label            = "${var.current-name-convention-core-public-module}mt"
    allocation_method            = "Static"
    tags = "${var.tags-mt-win-module}"
}
resource "azurerm_network_interface" "mt-nic-in" {
  depends_on = [var.mt_depend_on]
  name                 = "${var.current-name-convention-core-module}-mtwin-nicin"
  location            = "${var.preferred-location-module}" 
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "${var.current-name-convention-core-module}-mtwin-nicinconfig"
    subnet_id                     = "${var.subnet_in_id_module}" 
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.ip-in-mt-module}"
    public_ip_address_id          = "${azurerm_public_ip.mt-nic-puip.id}"
  }
  tags = "${var.tags-mt-win-module}"
}
resource "azurerm_virtual_machine" "mt-w2k16" {
  name                  = "${var.current-name-convention-core-module}-mtwin"
  location              = "${var.preferred-location-module}" 
  resource_group_name   = "${var.current-name-convention-core-module}-rg"
  network_interface_ids = ["${azurerm_network_interface.mt-nic-in.id}"]
  vm_size               = "${var.mt-size}"
  tags = "${var.tags-mt-win-module}"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       =  "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.current-name-convention-core-module}-mtwin-disk-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.current-name-convention-core-module}-mtwin"
    admin_username = "${var.mt-login}"
    admin_password = "${var.mt-passwd}" 
  }
  boot_diagnostics {
        enabled     = "true"
        storage_uri = "${var.stor-log-repo}"
    }
  os_profile_windows_config {
    provision_vm_agent = true
  }

}

resource "azurerm_virtual_machine_extension" "omsagent" {
  name                  = "${var.current-name-convention-core-module}-mtwin-omsagent"
  #location              = "${var.preferred-location-module}" 
  #resource_group_name   = "${var.current-name-convention-core-module}-rg"
  virtual_machine_id = "${azurerm_virtual_machine.mt-w2k16.id}"
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  settings = <<SETTINGS
        {
          "workspaceId": "${var.stor-log-ws-crd-1}"
        }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${var.stor-log-ws-crd-2}"
        }
PROTECTED_SETTINGS
}