variable "environment" {}
variable "prefix" {}
variable "region" {}
variable "region_name" {}

variable "default_tags" {}

variable "azs" {}

variable "vpc_cidr_block" {
  default = ""
}

variable "public_net_subnets" {
  default = []
}

variable "public_fw_subnets" {
  default = []
}

variable "private_main_subnets" {
  default = []
}

variable "private_db_subnets" {
  default = []
}

variable "single_nat" {
  default = false
}

variable "enable_network_firewall" {
  default = false
}

variable "enable_network_firewall_logs" {
  default = false
}

variable "network_firewall_stateful_rules" {
  default = []
}

variable "enable_vpc_flow_logs" {
  default = false
}