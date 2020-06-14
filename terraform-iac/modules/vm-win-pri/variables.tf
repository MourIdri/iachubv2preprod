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
variable "ip-in-dcaddns-module" {
  type    = any
  default = null
}

variable "dcaddns-passwd" {
  type    = any
  default = null
}
variable "dcaddns-login" {
  type    = any
  default = null
}
variable "security_appliance_depend_on" {
  type    = any
  default = null
}
variable "dcaddns-size" {
  type    = any
  default = null
}
variable "dcaddns_depend_on" {
  type    = any
  default = null
}
variable "stor-log-repo" {
  type    = any
  default = null
}
variable "tags-dcaddns-win-module" {
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
