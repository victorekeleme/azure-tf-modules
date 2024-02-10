resource "azurerm_public_ip" "this" {
  count = var.is_lb_private ? 0 : 1
  name                = "${local.lb_name}-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                     = "Standard"
  sku_tier                = "Regional"
  #   domain_name_label   = azurerm_resource_group.example.name

  tags = local.common_tags
}

resource "azurerm_lb" "this" {
  name                = local.lb_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = var.is_lb_private ? "${local.lb_name}-ip" : "${local.lb_name}-ip"
    public_ip_address_id = var.is_lb_private ? null : azurerm_public_ip.this[0].id
    private_ip_address_allocation = var.is_lb_private ? "Static" : null
    private_ip_address_version    = var.is_lb_private ? (var.private_ip_version != null ? var.private_ip_version : "IPv4") : null
    private_ip_address            = var.is_lb_private ? var.private_static_ip : null
    subnet_id = var.is_lb_private ? data.azurerm_subnet.subnet_name.id : null
  }
}

resource "azurerm_lb_backend_address_pool" "this" {
  loadbalancer_id = azurerm_lb.this.id
  name            = "${local.lb_name}-bepool"
}

resource "azurerm_lb_probe" "this" {
  for_each = var.lb_rules_probe != null ? var.lb_rules_probe : {}
  loadbalancer_id     = azurerm_lb.this.id
  name                = "lb_${each.key}_probe"
  port                = each.value.backend_port
  protocol            = each.value.protocol
  interval_in_seconds = each.value.interval_in_seconds
  probe_threshold     = each.value.probe_threshold
  number_of_probes    = each.value.number_of_probes
}

resource "azurerm_lb_rule" "this" {
  for_each = var.lb_rules_probe != null ? var.lb_rules_probe : {}
  name                           = "${local.lb_name}-${each.key}-lb_rule"
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  loadbalancer_id                = azurerm_lb.this.id
  frontend_ip_configuration_name = azurerm_lb.this.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  probe_id                       = azurerm_lb_probe.this[each.key].id
}
