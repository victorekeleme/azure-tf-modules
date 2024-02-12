resource "azurerm_availability_set" "this" {
  name                = "${local.vm_name}-av-set"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  platform_fault_domain_count = 3
  platform_update_domain_count = 3

  tags = local.common_tags
}


resource "azurerm_public_ip" "this" {
  count = var.is_vm_private ? 0 : var.vm_count
  name                = "${local.vm_name}-pub-ip-${sum([count.index, 1])}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "this" {
  count = var.vm_count != null ? var.vm_count : 1
  name                = "${local.vm_name}-${sum([count.index, 1])}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = var.environment != "prod" ? local.vm_size.nonprod : local.vm_size.prod
  admin_username      = var.admin_username
  network_interface_ids = [ element(azurerm_network_interface.this[*].id, count.index) ]
  availability_set_id = azurerm_availability_set.this.id
  # custom_data = ""

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_location)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.source_image_ref.publisher
    offer     = var.source_image_ref.offer
    sku       = var.source_image_ref.sku
    version   = var.source_image_ref.version
  }

  tags = local.common_tags

}

resource "azurerm_network_interface" "this" {
  count = var.vm_count # Using length(azurerm_linux_virtual_machine.this) gives a Cycle Error
  name                = "${local.vm_name}-nic-${sum([count.index, 1])}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "${local.vm_name}-ip-${sum([count.index, 1])}"
    subnet_id                     = data.azurerm_subnet.subnet_name.id
    private_ip_address_allocation = var.private_ip_allocation != null ?  var.private_ip_allocation : "Dynamic"
    public_ip_address_id =  var.is_vm_private ? null : azurerm_public_ip.this[count.index].id
    private_ip_address            = var.is_vm_private ? var.private_static_ip : null
  }

  tags = local.common_tags
}

# Network security group resource for vmss network interface
resource "azurerm_network_security_group" "this" {
  count = length(azurerm_network_interface.this)
  name                = "${local.vm_name}-vm-nsg-${sum([count.index, 1])}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  # Network security group rule resource
  dynamic "security_rule" {
    for_each = var.nic_inbound_ports != null ? var.nic_inbound_ports : []
    content {
      name                       = "vm-nsg-rule-${sum([security_rule.key, 1])}"
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


resource "azurerm_network_interface_security_group_association" "this" {
  count = length(azurerm_network_interface.this)   
  network_interface_id = azurerm_network_interface.this[count.index].id
  network_security_group_id = azurerm_network_security_group.this[count.index].id
}