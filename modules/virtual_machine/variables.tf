variable "hub_vnet_name" {
  type = string
  default = "devopsvault-dev-hub-vnet"
}

variable "hub_vnet_name_rg" {
  type = string
  default = "devopsvault-eastus-hub-vnet-rg"
}

variable "subnet_name" {
  type = string
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
  type = string
  default = "Victor Ekeleme"
}

variable "team" {
  type = string
  default = "DevOps"
}

variable "environment" {
  type    = string
  default = null
  validation {
    condition = contains(["dev","staging","prod"], lower(var.environment)) 
    error_message = "We only use the following environments dev || staging || prod)"
  }
}

variable "is_vm_private" {
  type = bool
  default = false
}

variable "vm_name" {
  type    = string
  default = "vm"
}

variable "vm_count" {
  type = number
  default = null
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
  type    = map(string)
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "private_ip_allocation" {
  type = string
  default = null
}