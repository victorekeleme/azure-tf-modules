output "virtual_machine_private_ips" {
  value = { for vm in azurerm_linux_virtual_machine.this : vm.id => vm.private_ip_address }
}

output "virtual_machine_public_ips" {
  value = { for vm in azurerm_linux_virtual_machine.this : vm.id => vm.public_ip_address }
}