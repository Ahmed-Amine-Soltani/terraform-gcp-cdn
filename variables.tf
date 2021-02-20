variable "google_compute_project_default_network_tier" {
  type        = string
  description = "The dns name to create which point to the CDN"
  default     = "PREMIUM"
}

variable "google_compute_global_address" {
  type        = string
  description = "The dns name to create which point to the CDN"
  default     = "EXTERNAL"
}


variable "dns_name" {
  type        = string
  description = "The dns name to create which point to the CDN"
  default     = ""
}

variable "google_dns_managed_zone_name" {
  type        = string
  description = "The name of the Google DNS Managed Zone where the DNS will be created"
  default     = ""
}

variable "google_storage_bucket_name" {
  type        = string
  description = "bucket name"
  default     = ""
}

variable "google_storage_bucket" {
  type = list(object({
    location         = string
    storage_class    = string
    force_destroy    = bool
    main_page_suffix = string
    not_found_page   = string
  }))
  default = [
    {
      location         = "australia-southeast1"
      storage_class    = "STANDARD"
      force_destroy    = true
      main_page_suffix = "index.html"
      not_found_page   = "404.html"
    }
  ]
}






