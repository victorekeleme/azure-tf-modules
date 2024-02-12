data "azurerm_virtual_network" "vnet_data" {
  name                = var.hub_vnet_name
  resource_group_name = var.hub_vnet_name_rg
}

output "vnet_subnet" {
  value = data.azurerm_virtual_network.vnet_data.subnets
}

data "azurerm_subnet" "subnet_name" {
  name = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet_data.name
  resource_group_name = data.azurerm_virtual_network.vnet_data.resource_group_name
}
data "terraform_remote_state" "lb_remote_state" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-statefiles-rg"
    storage_account_name = "terraformstatefilesa001"
    container_name       = "tfstatefile"
    key                  = "lbterraform.tfstate"
  }
}