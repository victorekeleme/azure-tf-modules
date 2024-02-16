variable "hub_vnet_name" {
  type    = string
  default = "devopsvault-dev-hub-vnet"
}

variable "hub_vnet_name_rg" {
  type    = string
  default = "devopsvault-eastus-hub-vnet-rg"
}

variable "subnet_id" {
  type    = string
  default = null
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

variable "environment" {
  type    = string
  default = null
  validation {
    condition     = contains(["dev", "staging", "prod"], lower(var.environment))
    error_message = "We only use the following environments dev || staging || prod)"
  }
}

variable "lb_name" {
  type    = string
  default = null
}

variable "lb_sku" {
  type = string
  default = "Basic"
}

variable "is_lb_internal" {
  type = bool
  default = false
}

variable "private_static_ip" {
  type = string
  default = null
}

variable "private_ip_addr_alloc" {
  type = string
  default = "Dynamic"
}

variable "private_ip_version" {
  type = string
  default = "IPv4"
}

variable "lb_rules" {
  type = map
  default = {
    "tcp" = {
      protocol      = "Tcp"
      frontend_port = 80
      backend_port  = 80
      probe_id = "tcp"
    }
    "udp" = {
      protocol      = "Udp"
      frontend_port = 80
      backend_port  = 80
      probe_id = "http"
    }
  }
}

variable "lb_probe" {
  type = map
  default = {
    "http" = {
      protocol      = "Http"
      port  = 80
      interval_in_seconds = 5
      number_of_probes  = 4
      probe_threshold = 3
      request_path = "/"
    }
  }
}

variable "virtual_machine_nic_ids" {
  type = list(string)
  default = null
}