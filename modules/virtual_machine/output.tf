output "virtual_machine_private_ips" {
  value = { for vm in azurerm_linux_virtual_machine.this : vm.id => vm.private_ip_address }
}

output "virtual_machine_public_ips" {
  value = { for vm in azurerm_linux_virtual_machine.this : vm.id => vm.public_ip_address }
}

output "virtual_machine_nic_ids" {
  value = { for nic in azurerm_network_interface.this : nic.id => nic.ip_configuration }
}

