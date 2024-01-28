resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space

  tags = local.common_tags
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets != null ? var.subnets : {}
  name                 = "${local.resource_prefix}-${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  private_endpoint_network_policies_enabled = false
  private_link_service_network_policies_enabled = false
  address_prefixes     = each.value

  dynamic "delegation" {
    for_each = contains(keys(var.subnet_service_delegation), each.key) ? var.subnet_service_delegation[each.key] : ({})
    content {
      name = delegation.key

      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}

resource "azurerm_route_table" "this" {
  for_each                      = azurerm_subnet.this
  name                          = "${local.resource_prefix}-${each.key}-rtb"
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  disable_bgp_route_propagation = true

  dynamic "route" {
    for_each = contains(keys(var.subnet_routes), each.key) ? var.subnet_routes[each.key] : ({})
    content {
      name                   = route.key
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
  tags = local.common_tags
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each       = azurerm_subnet.this
  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = azurerm_route_table.this[each.key].id
}

resource "azurerm_nat_gateway" "this" {
  for_each = var.natgw_subnets != null ? toset(var.natgw_subnets) : []
  name                = "${local.resource_prefix}-${each.key}-natgw"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each       = var.natgw_subnets != null ? toset(var.natgw_subnets) : []
  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = azurerm_nat_gateway.this[each.key].id
}