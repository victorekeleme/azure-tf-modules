output "load_balancer_id" {
  value = azurerm_lb.this.id
}

output "lb_private_fip" {
  value = var.is_lb_internal ? azurerm_lb.this.frontend_ip_configuration[0].private_ip_address : null
}

output "lb_be_address_pool" {
  value = azurerm_lb_backend_address_pool.this.id
}