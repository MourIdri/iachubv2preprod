# Create public IPs
resource "azurerm_network_interface" "dcaddns-nic-in" {
  depends_on = [var.dcaddns_depend_on]
  name                 = "${var.current-name-convention-core-module}-dom01-nicin"
  location            = "${var.preferred-location-module}" 
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "${var.current-name-convention-core-module}-dcaddnswin-nicinconfig"
    subnet_id                     = "${var.subnet_in_id_module}" 
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.ip-in-dcaddns-module}"
    #public_ip_address_id          = "${azurerm_public_ip.dcaddns-nic-puip.id}"
  }
  tags = "${var.tags-dcaddns-win-module}"
}
resource "azurerm_virtual_machine" "dcaddns-w2k16" {
  name                  = "${var.current-name-convention-core-module}-dom01"
  location              = "${var.preferred-location-module}" 
  resource_group_name   = "${var.current-name-convention-core-module}-rg"
  network_interface_ids = ["${azurerm_network_interface.dcaddns-nic-in.id}"]
  vm_size               = "${var.dcaddns-size}"
  tags = "${var.tags-dcaddns-win-module}"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       =  "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.current-name-convention-core-module}-dom01-disk-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.current-name-convention-core-module}-dom01"
    admin_username = "${var.dcaddns-login}"
    admin_password = "${var.dcaddns-passwd}" 
  }
  boot_diagnostics {
        enabled     = "true"
        storage_uri = "${var.stor-log-repo}"
    }
  os_profile_windows_config {
    provision_vm_agent = true
  }
}
resource "azurerm_virtual_machine_extension" "win-installansibleclient" {
    name                  = "${var.current-name-convention-core-module}-mtwin-installansibleclient"
    #location              = "${var.preferred-location-module}" 
    #resource_group_name   = "${var.current-name-convention-core-module}-rg"
    virtual_machine_id = "${azurerm_virtual_machine.dcaddns-w2k16.id}"
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    type_handler_version = "1.8"
    settings = <<SETTINGS
    {
        "fileUris": [
            "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
            ],
        "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
    }
SETTINGS
}
resource "azurerm_virtual_machine_extension" "win-omsagent" {
  name                  = "${var.current-name-convention-core-module}-dom01-omsagent"
  #location              = "${var.preferred-location-module}" 
  #resource_group_name   = "${var.current-name-convention-core-module}-rg"
  virtual_machine_id = "${azurerm_virtual_machine.dcaddns-w2k16.id}"
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