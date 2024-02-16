# product-env-appname

locals {
  resource_prefix = "${var.product_name}-${var.environment}"
  lb_name         = "${local.resource_prefix}-${var.lb_name}-lb"

  common_tags = {
    product_name = var.product_name
    environment  = var.environment
    location     = var.resource_group_location
    owner        = var.owner
    team         = var.team
  }
}
