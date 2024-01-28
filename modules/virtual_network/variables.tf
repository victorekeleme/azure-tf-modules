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

variable "environment" {
  type    = string
  default = null
}

variable "vnet_name" {
  type    = string
  default = null
}

variable "vnet_address_space" {
  type    = list(string)
  default = null
}

variable "subnets" {
  type    = map(list(string))
  default = null
}

variable "subnet_routes" {
  type = map(map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  })))
  default = null
}

variable "subnet_service_delegation" {
  type = map(map(object({
    name    = string
    actions = list(string)
  })))
  default = null
}

variable "natgw_subnets" {
  type    = list(string)
  default = null
}

