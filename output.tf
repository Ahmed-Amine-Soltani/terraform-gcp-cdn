output "dns_managed_zone_name" {
  value = data.google_dns_managed_zone.default.name
}

output "dns" {
  value = format("%s.%s", var.dns_name, data.google_dns_managed_zone.default.dns_name)
}