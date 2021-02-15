variable "dns_name" {
  type        = string
  description = "The dns name to create which point to the CDN"
}

variable "google_dns_managed_zone_name" {
  type        = string
  description = "The name of the Google DNS Managed Zone where the DNS will be created"
}

variable "google_storage_bucket" {
  type        = string
  description = "bucket name"
}