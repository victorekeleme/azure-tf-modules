resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.this.name

  tags = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  depends_on            = [azurerm_private_dns_zone.this]
  for_each              = var.virtual_network_ids != null ? var.virtual_network_ids : {}
  name                  = "${each.key}-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = "${each.value}"

  tags = local.common_tags
}

resource "azurerm_private_dns_a_record" "this" {
  for_each            = var.a_record_sets != null ? var.a_record_sets : {}
  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = each.value.ttl
  records             = each.value.records
}

resource "azurerm_private_dns_aaaa_record" "this" {
  for_each            = var.aaaa_record_sets != null ? var.aaaa_record_sets : {}
  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = each.value.ttl
  records             = each.value.records
}

resource "azurerm_private_dns_cname_record" "this" {
  for_each            = var.cname_record_sets != null ? var.cname_record_sets : {}
  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = each.value.ttl
  record              = each.value.records
}