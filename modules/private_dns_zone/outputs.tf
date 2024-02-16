output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.this.id
}

output "a_record_fqdn_ids" {
  value = { for a_record in azurerm_private_dns_a_record.this : a_record.fqdn => a_record.id }
}

output "aaaa_record_fqdn_ids" {
  value = { for aaaa_record in azurerm_private_dns_a_record.this : aaaa_record.fqdn => aaaa_record.id }
}

output "cname_record_fqdn_ids" {
  value = { for aaaa_record in azurerm_private_dns_a_record.this : aaaa_record.fqdn => aaaa_record.id }
}