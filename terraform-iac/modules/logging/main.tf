#BLOB storage to stor anylogs
resource "azurerm_storage_account" "hub-corpc-sto-acc-log" {
  name                     = "${var.current-name-convention-core-public-module}stolog"
  resource_group_name      = "${var.current-name-convention-core-module}-rg"
  location                 = "${var.preferred-location-module}"
  account_tier             = "${var.preferred-tier-storage-module}"
  account_replication_type = "${var.preferred-tier-storage-replication-module}" 
  depends_on = [var.stoc_depend_on_module]
  tags = "${var.tags-sto-logging-module}"
}
data "azurerm_storage_account_sas" "hub-corpc-sto-acc-log-sas" {
  connection_string = "${azurerm_storage_account.hub-corpc-sto-acc-log.primary_connection_string}"
  https_only        = true
  resource_types {
    service   = true
    container = true
    object    = true
  }
  services {
    blob  = true
    queue = true
    table = true
    file  = true
  }
  start  = timestamp()
  expiry = timeadd(timestamp(), "52560h")
  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
  }
}
resource "azurerm_key_vault" "current_key_vault" {
  depends_on = [var.stoc_depend_on_module]
  name                        = "${var.current-name-convention-core-public-module}kvlt"
  location                    = "${var.preferred-location-module}"
  resource_group_name         = "${var.current-name-convention-core-module}-rg"
  tenant_id                   = "${var.current-az-sp-tenant-id-module}"
  sku_name = "standard"
  tags = "${var.tags-repo-logging-module}"
  access_policy {
    tenant_id = "${var.current-az-sp-tenant-id-module}"
    object_id = "${var.current-az-sp-object-id-module}"
    key_permissions = [
      "get",
      "list",
      "create",
      "delete"
    ]
    secret_permissions = [
      "get",
      "list",
      "set",
      "delete"
    ]
    storage_permissions  = [
      "get",
      "list",
      "set",
      "delete"
    ]
  }
}
resource "azurerm_key_vault_secret" "current_key_vault_vm_def_password" {
  name                        = "current-vm-default-pass-main"
  value                       = "${var.current-vm-default-pass-module}"
  key_vault_id = azurerm_key_vault.current_key_vault.id
}
resource "azurerm_key_vault_secret" "current_key_vault_vm_def_username" {
  name                        = "current-vm-default-username-main"
  value                       = "${var.current-vm-default-username-module}"
  key_vault_id = azurerm_key_vault.current_key_vault.id
}

#Log analytics to do analysis
resource "azurerm_log_analytics_workspace" "hub-corpc-log-ana-rep" {
  name                = "${var.current-name-convention-core-module}-lgws-rep"
  location            = "${var.preferred-location-module}"
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  sku                 = "PerGB2018"
  depends_on = [var.logacc_depend_on_module]
  tags = "${var.tags-repo-logging-module}"
}

#output "hub-corpc-log-ana-rep-id" {
#  value = azurerm_log_analytics_workspace.hub-corpc-log-ana-rep.id
#}
#output "hub-corpc-log-ana-rep-primary-key" {
#  value = azurerm_log_analytics_workspace.hub-corpc-log-ana-rep.primary_shared_key
#}
#output "hub-corpc-log-ana-rep-primary-workspace-id" {
#  value = azurerm_log_analytics_workspace.hub-corpc-log-ana-rep.workspace_id
#}

#Create a security view with log anaitics
resource "azurerm_log_analytics_solution" "hub-corpc-log-ana-solsecu" {
  solution_name         = "Security"
  location              = "${var.preferred-location-module}"
  resource_group_name   = "${var.current-name-convention-core-module}-rg"
  #workspace_resource_id = "hub-corpc-log-ana-rep-id"
  workspace_resource_id = azurerm_log_analytics_workspace.hub-corpc-log-ana-rep.id
  workspace_name        = "${var.current-name-convention-core-module}-lgws-rep"
  depends_on = [azurerm_log_analytics_workspace.hub-corpc-log-ana-rep]
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Security"
  }
}    

resource "azurerm_eventhub_namespace" "hub-corpc-ev-hb-nmsp" {
  depends_on = [var.stoc_depend_on_module]
  name                = "${var.current-name-convention-core-public-module}corevthbnmsp"
  location            = "${var.preferred-location-module}"
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  sku                 = "Standard"
  capacity            = 1
  tags = "${var.tags-repo-logging-module}"
}

resource "azurerm_eventhub" "hub-corpc-ev-hb-1" {
  depends_on = [var.stoc_depend_on_module]
  name                = "${var.current-name-convention-core-public-module}corevthb1"
  namespace_name      = azurerm_eventhub_namespace.hub-corpc-ev-hb-nmsp.name
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "hub-corpc-ev-hb-1-rule-1" {
  depends_on = [var.stoc_depend_on_module,azurerm_eventhub.hub-corpc-ev-hb-1,azurerm_eventhub_namespace.hub-corpc-ev-hb-nmsp]
  name                = "${var.current-name-convention-core-public-module}corevthb1rule1"
  namespace_name      = azurerm_eventhub_namespace.hub-corpc-ev-hb-nmsp.name
  eventhub_name       = azurerm_eventhub.hub-corpc-ev-hb-1.name
  resource_group_name = "${var.current-name-convention-core-module}-rg"
  listen              = true
  send                = true
  manage              = true
}