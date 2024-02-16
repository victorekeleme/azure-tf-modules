variable "hub_vnet_name" {
  type    = string
  default = "devopsvault-dev-hub-vnet"
}

variable "hub_vnet_name_rg" {
  type    = string
  default = "devopsvault-eastus-hub-vnet-rg"
}

variable "subnet_name" {
  type    = string
  default = "public-subnet"
}

variable "subscription_id" {
  type    = string
  default = null
}

variable "tenant_id" {
  type    = string
  default = null
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "resource_group_location" {
  type    = string
  default = null
}

variable "product_name" {
  type    = string
  default = null
}

variable "owner" {
  type    = string
  default = "Victor Ekeleme"
}

variable "team" {
  type    = string
  default = "DevOps"
}

# variable "environment" {
#   type    = string
#   default = null
#   validation {
#     condition     = contains(["dev", "staging", "prod"], lower(var.environment))
#     error_message = "We only use the following environments dev || staging || prod)"
#   }
# }

variable "private_dns_zone_name" {
  type    = string
  default = "devopsvault.com"
}

variable "virtual_network_ids" {
  type    = map
  default = null
}

variable "a_record_sets" {
  type    = map(any)
  default = null
}

variable "aaaa_record_sets" {
  type    = map(any)
  default = null
}

variable "cname_record_sets" {
  type    = map(any)
  default = null
}
