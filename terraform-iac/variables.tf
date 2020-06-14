############################
# Authentication variables #
############################
# Add you service endpoint access strings

#variable "azure-client-app-id" {
#    type        = any
#    description="The Client ID of the Service Principal."
#}
#variable "azure-subscription-id" {
#    type        = any
#    description="The ID of the Azure Subscription in which to run the Acceptance Tests."
#}
#variable "azure-client-secret-password" {
#    type        = any
#    description="The Client Secret associated with the Service Principal."
#}
#variable "azure-tenant-id" {
#    type        = any
#    description="The Tenant ID to use."
#}
############################
# GENERAL TENANT VARIABLES #
############################

variable "preferred-location-main" {
  description = "Location of the network"
  default     = "westeurope"
}

variable "second-location-main" {
  description = "Location of the network"
  default     = "northeurope"
}
variable "current-name-convention-core-main" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  default     = "cc-pp-hb"
}

variable "current-name-convention-core-public-main" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  default     = "ccppdhb"
}
############################
# GENERAL NETWRK VARIABLES #
############################
variable "current-vnet-space" {
  description = "defining the vnetspace using a variable"
  type = any
}

#LOGIN PASSWORDS
variable "genericusername" {
  description = "Username for Virtual Machines"
  default     = "demouser"
}
variable "genericpassword" {
  description = "Password for Virtual Machines"
  default     = "M0nP@ssw0rd!"
}
#INSTANCE CATALOGUE 
variable "vmsize_small_1_2" {
  description = "Size of the VMs"
  default     = "Standard_F1s"
}
variable "vmsize_small_1_4" {
  description = "Size of the VMs"
  default     = "Standard_DS1_v2"
}
variable "vmsize_medium_2_4" {
  description = "Size of the VMs"
  default     = "Standard_F2s_v2"
}
variable "vmsize_medium_2_8" {
  description = "Size of the VMs"
  default     = "Standard_D2s_v3"
}
variable "vmsize_high_4_8" {
  description = "Size of the VMs"
  default     = "Standard_F4s_v2"
}
variable "vmsize_high_4_16" {
  description = "Size of the VMs"
  default     = "Standard_D4s_v3"
}
