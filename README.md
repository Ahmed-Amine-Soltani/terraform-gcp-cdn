

Setting up a CDN on GCP via Terraform 





<img alt="GitHub tag (latest SemVer)" src="https://img.shields.io/github/v/tag/Ahmed-Amine-Soltani/terraform-gcp-cdn">

This module allows you to setting up a CDN on GCP 

This module allow you to host a static website on Cloud Storage bucket for a domain you own behind a CDN on [Google Cloud Platform Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)



The ressources that will be created in your project:

- An external IP address  [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) [link](https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address#reserve_new_static)

- An entry in Cloud DNS to map the IP address to the domain name [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) [link](https://cloud.google.com/dns/docs/tutorials/create-domain-tutorial#set-up-domain)
- A GCS bucket [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) [link](https://cloud.google.com/storage/docs/hosting-static-website)
- A https external load balancer with CDN  [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) [link](https://cloud.google.com/load-balancing/docs/https) 
- A http external load balancer to redirect HTTP traffic to HTTPS [link]()  [link](https://cloud.google.com/cdn/docs/setting-up-http-https-redirect#partial-http-lb)
- A managed certificate for HTTPS [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) [link](https://cloud.google.com/load-balancing/docs/ssl-certificates/google-managed-certs)



Before starting you’ll need some pre-existing configurations:

- An existing GCP account linked to a billing account
- An existing GCP project
- A service account with a key
- Terraform installed and configured on your machine
- A domain name managed in Cloud DNS (Public Zone)
- Some files to upload to the bucket



architecture

<img src="https://i.ibb.co/8P7g9v7/gcp-cdn-architecture.png" alt="gcp-cdn-architecture" border="0" />

the steps to use the module 

```
terraform {
  required_version = ">= 0.13.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.52.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.52.0"
    }
  }
}

# GCP provider
provider "google" {
  credentials = file(var.key)
  project     = var.google_project
  region      = var.region
  zone        = var.zone
}

# GCP beta provider
provider "google-beta" {
  credentials = file(var.key)
  project     = var.google_project
  region      = var.region
 } 
```

