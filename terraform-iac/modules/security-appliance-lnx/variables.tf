
############################
# Authentication variables #
############################
# Add you service endpoint access strings

variable "azure-client-app-id" {
    default="4d677e63-630b-4a92-8d87-ad8a1f549e7a"
    description="The Client ID of the Service Principal."
}
variable "azure-subscription-id" {
    default="0baec21d-4157-499e-8f2f-9a42236a6f39"
    description="The ID of the Azure Subscription in which to run the Acceptance Tests."
}
variable "azure-client-secret-password" {
    default="e4c25b06-b8d6-4e37-ae8b-dbb55c8c2e88"
    description="The Client Secret associated with the Service Principal."
}

variable "azure-tenant-id" {
    default="72f988bf-86f1-41af-91ab-2d7cd011db47"
    description="The Tenant ID to use."
}
############################
# GENERAL TENANT VARIABLES #
############################

variable "preferred-location-module" {
  description = "Location of the network"
  #default     = "westeurope"
}

variable "current-name-convention-core-module" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  #default     = "crpc-prod-shar-hub"
}

variable "current-name-convention-core-public-module" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  #default     = "crcprdshrhub"
}
variable "subnet_out_id_module" {
  type    = any
  default = null
}
variable "subnet_in_id_module" {
  type    = any
  default = null
}
variable "ip-in-nva-module" {
  type    = any
  default = null
}
variable "ip-out-nva-module" {
  type    = any
  default = null
}
variable "nva-passwd" {
  type    = any
  default = null
}
variable "nva-login" {
  type    = any
  default = null
}
variable "security_appliance_depend_on" {
  type    = any
  default = null
}
variable "nva-size" {
  type    = any
  default = null
}
variable "stor-log-repo" {
  type    = any
  default = null
}
variable "stor-log-repo-name" {
  type    = any
  default = null
}
variable "stor-log-repo-sas" {
  type    = any
  default = null
}
variable "tags-security-appliance-dmz-module" {
  type    = any
  default = null
}
variable "stor-log-ws-crd-1" {
  type    = any
  default = null
}
variable "stor-log-ws-crd-2" {
  type    = any
  default = null
}
variable "ev-hb-log-id" {
  type    = any
  default = null
}
variable "ev-hb-log-pri-conx-string" {
  type    = any
  default = null
}
variable "ev-hb-log-pri-conx-key" {
  type    = any
  default = null
}
