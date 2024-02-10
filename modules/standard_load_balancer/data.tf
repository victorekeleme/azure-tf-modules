data "azurerm_virtual_network" "vnet_data" {
  name                = var.hub_vnet_name
  resource_group_name = var.hub_vnet_name_rg
}

output "vnet_subnet" {
  value = data.azurerm_virtual_network.vnet_data.subnets
}

data "azurerm_subnet" "subnet_name" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet_data.name
  resource_group_name  = data.azurerm_virtual_network.vnet_data.resource_group_name
}


