output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "vnet_address_space" {
  value = azurerm_virtual_network.this.resource_group_name
}

output "subnet_ids" {
  value = [ for subnet in azurerm_subnet.this : subnet.id] 
}

output "subnet_name_id" {
  value = { for subnet in azurerm_subnet.this : subnet.id => subnet.name } 
}

output "subnet_routes_ids" {
  value = { for rtb in azurerm_route_table.this : rtb.id => rtb.subnets }
}

output "nat_gateway_ids" {
  value = [ for natgw in azurerm_nat_gateway.this : natgw.id ]
}