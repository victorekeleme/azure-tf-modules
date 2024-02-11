output "load_balancer_id" {
  value = azurerm_lb.this.id
}

output "load_balancer_fip" {
  value = azurerm_lb.this.frontend_ip_configuration
}