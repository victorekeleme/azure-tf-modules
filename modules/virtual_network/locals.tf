# product-env-appname

locals {
  resource_prefix     = "${var.product_name}-${var.environment}"
  resource_group_name = "${var.product_name}-${var.resource_group_location}"
  vnet_name           = "${local.resource_prefix}-${var.vnet_name}"

  common_tags = {
    product_name = var.product_name
    environment  = var.environment
    location     = var.resource_group_location
    owner        = var.owner
    team         = var.team
  }
}

