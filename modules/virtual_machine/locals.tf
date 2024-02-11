# product-env-appname

locals {
  resource_prefix     = "${var.product_name}-${var.environment}"
  vm_name             = "${local.resource_prefix}-${var.vm_name}"
  
  vm_size = {
    nonprod = "Standard_B2s"
    prod = "Standard_D2s_v3"
  }
  common_tags = {
    product_name = var.product_name
    environment  = var.environment
    location     = var.resource_group_location
    owner        = var.owner
    team         = var.team
  }
}

