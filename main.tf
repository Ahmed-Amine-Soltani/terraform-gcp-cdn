############################# Network configuration #############################
# The default network tier to be configured for the project
resource "google_compute_project_default_network_tier" "default" {
  network_tier = "PREMIUM"
}

# Reserve an external IP
resource "google_compute_global_address" "default" {
  name         = "static-website-lb-ip"
  address_type = "EXTERNAL"
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


############################# Bucket configuration #############################
# Bucket to store website
resource "google_storage_bucket" "bucket" {
  name          = var.google_storage_bucket
  location                    = "australia-southeast1"
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = false
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Make new objects public
resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

############################# LoadBalancer and CDN creation #############################
# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "static-website" {
  name                  = "static-website-forwarding-rule"
  target                = google_compute_target_https_proxy.static-website.id
  port_range            = "443"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.default.address
}


# GCP target proxy
resource "google_compute_target_https_proxy" "static-website" {
  name             = "static-website-https-proxy"
  url_map          = google_compute_url_map.static-website.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "default" {
  name = "static-website-cert"

  managed {
    domains = [
      google_dns_record_set.a.name,
      google_dns_record_set.cname.name
    ]
  }
}

# GCP URL MAP
resource "google_compute_url_map" "static-website" {
  name            = "url-map-https-target-proxy"
  description     = "a description"
  default_service = google_compute_backend_bucket.default.id
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "default" {
  name        = "static-website-backend-bucket"
  description = "Contains beautiful images"
  bucket_name = google_storage_bucket.bucket.name
  enable_cdn  = true
}

############################# HTTP-to-HTTPS redirect for HTTP(S) Load Balancing ############################
# GCP forwarding rule http to https
resource "google_compute_global_forwarding_rule" "static-website-forwording" {
  name                  = "static-website-http-to-https-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  port_range            = 80
  target                = google_compute_target_http_proxy.static-website-forwording.id
  ip_address            = google_compute_global_address.default.address
}

# GCP target prox http to https
resource "google_compute_target_http_proxy" "static-website-forwording" {
  name    = "static-website-http-proxy"
  url_map = google_compute_url_map.static-website-forwording.id
}

# GCP target prox http to https
resource "google_compute_url_map" "static-website-forwording" {
  name = "url-map-http-target-proxy"
  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}










