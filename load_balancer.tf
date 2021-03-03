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
  name             = "static-website-cert"
  url_map          = google_compute_url_map.static-website.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}


# GCP URL MAP
resource "google_compute_url_map" "static-website" {
  name            = "url-map-https-target-proxy"
  default_service = google_compute_backend_bucket.default.id
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "default" {
  name        = "static-website-backend-bucket"
  bucket_name = google_storage_bucket.bucket.name
  enable_cdn  = true
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


############################# HTTP-to-HTTPS redirect for HTTP(S) Load Balancing ############################
# GCP forwarding rule http to https
resource "google_compute_global_forwarding_rule" "static-website-forwording" {
  name                  = "static-website-http-to-https-forwarding-rule"
  port_range            = "80"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
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