output "dns_managed_zone_name" {
  value = data.google_dns_managed_zone.default.name
}

output "external_ip_reserved" {
  value = google_compute_global_address.default.address
}

output "lb_fqdn" {
  value = format("%s.%s", var.dns_name, data.google_dns_managed_zone.default.dns_name)
}