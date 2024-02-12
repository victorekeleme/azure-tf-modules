output "load_balancer_id" {
  value = azurerm_lb.this.id
}

output "load_balancer_fip" {
  value = azurerm_lb.this.frontend_ip_configuration
}

output "lb_be_address_pool" {
  value = azurerm_lb_backend_address_pool.this.id
}