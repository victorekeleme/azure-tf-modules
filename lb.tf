# module "applb" {
#   source = "./modules/standard_load_balancer"

#   resource_group_name     = "lb"
#   resource_group_location = "eastus"
#   product_name            = "devopsvault"
#   environment             = "dev"
#   subnet_id             = module.virtual_network.subnet_name_id["private-subnet"]

#   lb_name           = "private"
#   is_lb_internal     = true
#   # private_static_ip = "10.0.10.10"
# }