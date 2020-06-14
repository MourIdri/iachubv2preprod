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
