# module "vnet_dns" {
#   depends_on = [module.virtual_network, module.applb]
#   source     = "./modules/private_dns_zone"

#   resource_group_name     = "azure-dns"
#   resource_group_location = "eastus"
#   product_name            = "devopsvault"

#   private_dns_zone_name = "devopsvault.com"
#   virtual_network_ids   = module.virtual_network.vnet_attr
#   a_record_sets = {
#     applb = {
#         ttl = 300
#         records = [ module.applb.lb_private_fip ]
#     }
#   }

# }