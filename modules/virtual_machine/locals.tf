# product-env-appname

locals {
  resource_prefix     = "${var.product_name}-${var.environment}"
  vm_name             = "${local.resource_prefix}-${var.vm_name}"
  
  vm_size = {
    lower_env = "Standard_Bs2"
    prod_env = "Standard_D2s_v3"
  }
  common_tags = {
    product_name = var.product_name
    environment  = var.environment
    location     = var.resource_group_location
    owner        = "Victor Ekeleme"
    team         = "SRE"
  }
}

