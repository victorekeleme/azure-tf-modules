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

variable "storage_account_name" {
  type    = string
  default = null

  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "Storage account name must be between 3 and 24 characters."
  }
}

variable "account_tier" {
  type    = string
  default = null
}

variable "account_replication_type" {
  type    = string
  default = null
}

variable "storage_network_rules" {
  type    = map(any)
  default = null
}

variable "account_kind" {
  type    = string
  default = null
}

variable "storage_container" {
  type = map(string)
  default = {
    "tffilesstg" = "container"
    "personal" = "private"
  }
  validation {
    condition     = length([for val in values(var.storage_container) : val if !can(regex("^(blob|container|private)$", val))]) == 0
    error_message = "container_access_type accepts only the use of the following types blob, container or private)"
  }
  # blob ==> !can(true) ==> false
  # allow ==> !can(false) ==> true
  description = <<-EOT
    For example =>
    {
       container_name[any] = container_access_type [blob, container or private. Defaults to private]
    }
  EOT
}

variable "storage_blobs" {
  type = map
  default = {
   blob1 = {
    name = "index.html"
    type = "Block"
    source = null
    storage_container = "tffilesstg"
   }
  }
  validation {
    condition = length([for val in values(var.storage_blobs) : val.type if !can(regex("^(Block|Page|Append)$", val.type))]) == 0
    error_message = "storage_blobs type accepts only the use of the following types Block, Page or Append))"
  }
}
