resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "${local.vmss_name}-vmss"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.vm_sku
  instances           = var.instance_count == null ? 1 : var.instance_count
  admin_username      = var.admin_username

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
    primary = true

    ip_configuration {
      name      = "${local.vmss_name}-ip"
      primary   = true
      subnet_id = data.azurerm_subnet.subnet_name.id
    }
  }

  tags = local.common_tags
}