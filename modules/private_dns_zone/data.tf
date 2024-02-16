data "terraform_remote_state" "vnet_data" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-statefiles-rg"
    storage_account_name = "terraformstatefilesa001"
    container_name       = "tfstatefile"
    key                  = "terraform.tfstate"
  }
}