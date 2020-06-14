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
variable "ip-in-mgmt-module" {
  type    = any
  default = null
}

variable "mgmt-passwd" {
  type    = any
  default = null
}
variable "mgmt-login" {
  type    = any
  default = null
}
variable "security_appliance_depend_on" {
  type    = any
  default = null
}
variable "mgmt-size" {
  type    = any
  default = null
}
variable "mgmt_depend_on" {
  type    = any
  default = null
}
variable "stor-log-repo" {
  type    = any
  default = null
}
variable "vpn_gw_depend_on" {
  type    = any
  default = null
}
variable "subnet-vpn-target-id-module" {
  type    = any
  default = null
}
variable "corph-s2s-connection-pass" {
  type    = any
  default = null
}
variable "ipaddress-routeur-onprem-1-module" {
  type    = any
  default = null
}
variable "iprange-onprem-module" {
  type    = any
  default = null
}
variable "tags-vpn-standard-connect-module" {
  type    = any
  default = null
}
variable "tags-onprem-1-standard-connect-module" {
  type    = any
  default = null
}
