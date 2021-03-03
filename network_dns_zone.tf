############################# Network configuration #############################
# The default network tier to be configured for the project
resource "google_compute_project_default_network_tier" "default" {
  network_tier = var.google_compute_project_default_network_tier
}

# Reserve an external IP
resource "google_compute_global_address" "default" {
  name         = "static-website-lb-ip"
  address_type = var.google_compute_global_address_type
}

# Get the managed DNS zone
data "google_dns_managed_zone" "default" {
  name = var.google_dns_managed_zone_name
}

# Add the IP to the DNS
resource "google_dns_record_set" "a" {
  name         = format("%s.%s", var.dns_name, data.google_dns_managed_zone.default.dns_name)
  managed_zone = data.google_dns_managed_zone.default.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.default.address]
}

# www to non-www redirect
resource "google_dns_record_set" "cname" {
  name         = format("%s.%s.%s", "www", var.dns_name, data.google_dns_managed_zone.default.dns_name)
  managed_zone = data.google_dns_managed_zone.default.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = [format("%s.%s", var.dns_name, data.google_dns_managed_zone.default.dns_name)]
}