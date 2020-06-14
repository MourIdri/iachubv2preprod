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
variable "rg_depends_on" {
  type    = any
  default = null
}
variable "tags-rg-module" {
  type    = any
  default = null
}