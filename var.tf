variable "identity" {}
variable "tenant_name" {}
variable "tenant_id" {}
variable "username" {}
variable "password" {
	default=""
}
variable "key_pair_name" {}
variable "floating_ip_pool" {}
variable "network_external_id" {}
variable "region" {}
variable "network" {}
variable "flavor_id_opsman" {}
variable "flavor_id_jumpbox" {}
variable "image_id_jumpbox" {}