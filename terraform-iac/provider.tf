provider "azurerm" {
  version="2.0.0"
  features {}
}

terraform {
  required_version = "0.12.24"
  backend "azurerm" {
    storage_account_name = "srv${var.current-name-convention-core-public-module}tfsa"
    container_name       = "terraform"
    key                  = "terraform-${var.current-name-convention-core-public-module}.tfstate"
    access_key           = "${var.tf_storage_account_key}"
  }
}
