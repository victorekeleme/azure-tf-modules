# product-env-appname

locals {
  resource_prefix     = "${var.product_name}"
  private_dns_name             = "${local.resource_prefix}-${var.private_dns_zone_name}"
  


  common_tags = {
    product_name = var.product_name
    location     = var.resource_group_location
    owner        = var.owner
    team         = var.team
  }
}

