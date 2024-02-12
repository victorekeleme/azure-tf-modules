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

variable "environment" {
  type    = string
  default = null
  validation {
    condition     = contains(["dev", "staging", "prod"], lower(var.environment))
    error_message = "We only use the following environments dev || staging || prod)"
  }
}

variable "vmss_name" {
  type    = string
  default = "app-server"
}

variable "instance_count" {
  type    = number
  default = null
}

variable "vm_sku" {
  type    = string
  default = "Standard_F2"
}

variable "admin_username" {
  type    = string
  default = "admin_user"
}

variable "public_key_location" {
  type    = string
  default = null
}

variable "source_image_ref" {
  type = map(string)
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "lb_be_pool_ids" {
  type = list(string)
  default = null
}

variable "nic_inbound_ports" {
  type = list(string)
  default = [ "8080", "22" ]
}


# variable "private_ip_allocation" {
#   type = string
#   default = null
# }

# variable "is_vmss_private" {
#   type = bool
#   default = true
# }