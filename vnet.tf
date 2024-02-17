module "virtual_network" {
  source = "./modules/virtual_network"

  resource_group_name     = "devopsvault"
  resource_group_location = "eastus"
  product_name            = "devopsvault"
  environment             = "dev"
  vnet_name               = "mgmt-vnet"
  vnet_address_space      = ["10.0.0.0/16"]
  subnets = {
    "public"   = ["10.0.0.0/24"]
    "private"  = ["10.0.10.0/24"]
    "database" = ["10.0.20.0/24"]
  }
  subnet_routes = {
    "public" = {
      "route1" = {
        address_prefix         = "10.0.0.0/24"
        next_hop_type          = "VnetLocal"
        next_hop_in_ip_address = null
      }
    }
  }
  subnet_service_delegation = {
    "public" = {
      "service_delegation_1" = {
        name = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]

      }
    }
  }
  natgw_subnets = ["public"]

  private_dns_zone_name = "devopsvault.com"
}