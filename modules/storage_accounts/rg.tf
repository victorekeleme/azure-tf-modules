resource "azurerm_resource_group" "this" {
  name     = "${local.resource_prefix}-${var.resource_group_name}-rg"
  location = var.resource_group_location
  tags     = local.common_tags
}
