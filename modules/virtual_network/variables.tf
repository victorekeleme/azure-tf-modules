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

variable "environment" {
  type    = string
  default = null
  validation {
    condition     = contains(["dev", "staging", "prod"], lower(var.environment))
    error_message = "We only use the following environments dev || staging || prod)"
  }
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
  default = {}
}

variable "subnet_routes" {
  type = map(map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  })))
  default = {}
}

variable "subnet_service_delegation" {
  type = map(map(object({
    name    = string
    actions = list(string)
  })))
  default = {}
}

variable "natgw_subnets" {
  type    = list(string)
  default = null
}

variable "subnet_inbound_ports" {
  type = map(list(string))
  default = {
    "public"  = ["22", "80", "443"]
    "private" = ["22", "8080", "443"]
  }
}

variable "private_dns_zone_name" {
  type    = string
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
