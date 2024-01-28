module "mgmt-vnet" {
  source = "./modules/virtual_network"
  
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  product_name = var.product_name
  environment = var.environment
  vnet_name = var.vnet_name
  vnet_address_space = var.vnet_address_space
  subnets = var.subnets
  subnet_routes = var.subnet_routes
  subnet_service_delegation = var.subnet_service_delegation
  natgw_subnets = var.natgw_subnets
}