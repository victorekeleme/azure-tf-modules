# # module "mgmt-vnet" {
# #   source = "./modules/virtual_network"

# #   vnet_name                 = var.vnet_name
# #   resource_group_name       = var.resource_group_name
# #   resource_group_location   = var.resource_group_location
# #   product_name              = var.product_name
# #   environment               = var.environment
# #   vnet_address_space        = var.vnet_address_space
# #   subnets                   = var.subnets
# #   subnet_routes             = var.subnet_routes
# #   subnet_service_delegation = var.subnet_service_delegation
# #   natgw_subnets             = var.natgw_subnets
# # }

# module "virtual_network" {
#   source = "./modules/virtual_network"

#   resource_group_name     = "devopsvault"
#   resource_group_location = "eastus"
#   product_name            = "devopsvault"
#   environment             = "dev"
#   vnet_name               = "mgmt-vnet"
#   vnet_address_space      = ["10.0.0.0/16"]
#   subnets = {
#     "public" = ["10.0.0.0/24"]
#     "appgw"  = ["10.0.10.0/24"]
#     "private"    = ["10.0.20.0/24"]
#   }
#   subnet_routes = {
#     "public" = {
#       "route1" = {
#         address_prefix         = "10.0.0.0/24"
#         next_hop_type          = "VnetLocal"
#         next_hop_in_ip_address = null
#       }
#     }
#   }
#   subnet_service_delegation = {
#     "public" = {
#       "service_delegation_1" = {
#         name    = "Microsoft.ContainerInstance/containerGroups"
#         actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", 
#                   "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]

#       }
#     }
#   }
#   natgw_subnets = ["public"]
# }