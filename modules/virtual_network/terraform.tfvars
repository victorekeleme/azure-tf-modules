subscription_id = "c071899a-cdba-4fb3-a7ba-f85ad1adda83"
tenant_id       = "68f13a7e-9040-46f5-8da8-0612138e08f3"

resource_group_name     = "devopsvault"
resource_group_location = "eastus"
product_name            = "devopsvault"
environment             = "dev"
vnet_name               = "hub-vnet"
vnet_address_space      = ["10.0.0.0/16"]
subnets = {
  "public"   = ["10.0.0.0/24"]
  "private"  = ["10.0.10.0/24"]
  "database" = ["10.0.20.0/24"]
}
subnet_routes             = {}
subnet_service_delegation = {}
natgw_subnets             = null

