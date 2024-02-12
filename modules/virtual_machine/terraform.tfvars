subscription_id = "c071899a-cdba-4fb3-a7ba-f85ad1adda83"
tenant_id       = "68f13a7e-9040-46f5-8da8-0612138e08f3"

resource_group_name     = "vm"
resource_group_location = "eastus"
product_name            = "devopsvault"
environment             = "dev"

vm_name = "wordpress"
vm_count = 2
is_vm_private = true
admin_username = "admin_user"
public_key_location = "~/.ssh/id_rsa.pub"
source_image_ref = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
}

