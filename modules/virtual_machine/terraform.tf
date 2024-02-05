terraform {
  required_version = "~> 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-statefiles-rg"
    storage_account_name = "terraformstatefilesa001"
    container_name       = "tfstatefile"
    key                  = "vmterraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
  features {}
}
