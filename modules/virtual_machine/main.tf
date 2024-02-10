resource "azurerm_linux_virtual_machine" "this" {
  count = var.vm_count != null ? var.vm_count : 1
  name                = "${local.vm_name}-${count.index}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = var.environment != "prod" ? local.vm_size.lower_env : local.vm_size.prod_env
  admin_username      = var.admin_username
  network_interface_ids = [ element(azurerm_network_interface.this[*].id, count.index) ]
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
  count = var.vm_count
  name                = "${local.vm_name}-nic-${count.index}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "${local.vm_name}-ip-${count.index}"
    subnet_id                     = data.azurerm_subnet.public_subnet_name.id
    private_ip_address_allocation = var.private_ip_allocation != null ?  var.private_ip_allocation : "Dynamic"
    public_ip_address_id =  var.is_vm_private ? null : azurerm_public_ip.this[count.index].id
  }

  tags = local.common_tags
}


resource "azurerm_public_ip" "this" {
  count = var.is_vm_private ? 0 : var.vm_count
  name                = "${local.vm_name}-pub-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
}
