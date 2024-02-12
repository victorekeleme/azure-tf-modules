resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "${local.vmss_name}-vmss"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.vm_sku
  instances           = var.instance_count == null ? 1 : var.instance_count
  admin_username      = var.admin_username
  upgrade_mode = "Automatic"

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_location)
  }

  source_image_reference {
    publisher = var.source_image_ref.publisher
    offer     = var.source_image_ref.offer
    sku       = var.source_image_ref.sku
    version   = var.source_image_ref.version
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${local.vmss_name}-nic"
    network_security_group_id = azurerm_network_security_group.this.id
    primary = true

    ip_configuration {
      name      = "${local.vmss_name}-ip"
      primary   = true
      subnet_id = data.azurerm_subnet.subnet_name.id
      load_balancer_backend_address_pool_ids = [ data.terraform_remote_state.lb_remote_state.outputs.lb_be_address_pool ]
    }
  }

  tags = local.common_tags
}


# Network security group resource for vmss network interface
resource "azurerm_network_security_group" "this" {
  name                = "${local.vmss_name}-vmss-nsg"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  # Network security group rule resource
  dynamic "security_rule" {
    for_each = var.nic_inbound_ports != null ? var.nic_inbound_ports : []
    content {
      name                       = "vmss-nsg-rule-${security_rule.key}"
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