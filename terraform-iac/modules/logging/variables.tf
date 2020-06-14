############################
# GENERAL TENANT VARIABLES #
############################

variable "preferred-location-module" {
  description = "Location of the network"
  default     = "westeurope"
}

variable "second-location-module" {
  description = "Location of the network"
  default     = "northeurope"
}
variable "current-name-convention-core-module" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  default     = "crpc-prod-shar-hub"
}

variable "current-name-convention-core-public-module" {
  description = "Every PUBLIC accesed and resolved ressources has a core model crcprdshrhubstolog "
  default     = "crcprdshrhub"
}

variable "preferred-tier-storage-module" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  default     = "Standard"
}

variable "preferred-tier-storage-replication-module" {
  description = "Every ressources has a core model crpc-prod-shar-hub-subnet-publicdmzin "
  default     = "LRS"
}
variable "tags-sto-logging-module" {
  type    = any
  default = null
}
variable "stoc_depend_on_module" {
  type    = any
  default = null
}
variable "tags-repo-logging-module" {
  type    = any
  default = null
}
variable "logacc_depend_on_module" {
  type    = any
  default = null
}