resource "azurerm_resource_group" "this" {
  name     = "${local.resource_prefix}-${var.vnet_name}-vnet-rg"
  location = var.resource_group_location
  tags     = local.common_tags
}


