resource "azurerm_virtual_network" "this" {
  name                = "${local.vnet_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space

  tags = local.common_tags
}

resource "azurerm_subnet" "this" {
  for_each                                      = var.subnets != null ? var.subnets : {}
  name                                          = "${each.key}-subnet"
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  private_endpoint_network_policies_enabled     = false
  private_link_service_network_policies_enabled = false
  address_prefixes                              = each.value

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
  name                          = "${each.key}-rtb"
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
  for_each            = var.natgw_subnets != null ? toset(var.natgw_subnets) : []
  name                = "${each.key}-natgw"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each       = var.natgw_subnets != null ? toset(var.natgw_subnets) : []
  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = azurerm_nat_gateway.this[each.key].id
}


# Subnet and network security group association
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = azurerm_subnet.this
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

# Network security group resource for subnets
resource "azurerm_network_security_group" "this" {
  for_each            = azurerm_subnet.this
  name                = "${each.key}-nsg"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  # Network security group rule resource subnets
  dynamic "security_rule" {
    for_each = contains(keys(var.subnet_inbound_ports), each.key) ? var.subnet_inbound_ports[each.key] : []
    content {
      name                       = "${each.key}-nsg-rule-${security_rule.value}"
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_private_dns_zone" "this" {
  depends_on            = [azurerm_virtual_network.this]
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.this.name

  tags = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  depends_on            = [azurerm_private_dns_zone.this, azurerm_virtual_network.this]
  name                  = "${local.vnet_name}-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled = true

  tags = local.common_tags
}

# resource "azurerm_private_dns_a_record" "this" {
#   for_each            = var.a_record_sets != null ? var.a_record_sets : {}
#   name                = each.key
#   zone_name           = azurerm_private_dns_zone.this.name
#   resource_group_name = azurerm_resource_group.this.name
#   ttl                 = each.value.ttl
#   records             = each.value.records
# }

# resource "azurerm_private_dns_aaaa_record" "this" {
#   for_each            = var.aaaa_record_sets != null ? var.aaaa_record_sets : {}
#   name                = each.key
#   zone_name           = azurerm_private_dns_zone.this.name
#   resource_group_name = azurerm_resource_group.this.name
#   ttl                 = each.value.ttl
#   records             = each.value.records
# }

# resource "azurerm_private_dns_cname_record" "this" {
#   for_each            = var.cname_record_sets != null ? var.cname_record_sets : {}
#   name                = each.key
#   zone_name           = azurerm_private_dns_zone.this.name
#   resource_group_name = azurerm_resource_group.this.name
#   ttl                 = each.value.ttl
#   record              = each.value.records
# }