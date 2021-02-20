

# <p align="center"> Terraform CDN Module </p> 



<img alt="GitHub tag (latest SemVer)" src="https://img.shields.io/github/v/tag/Ahmed-Amine-Soltani/terraform-gcp-cdn">





This modules makes it easy to host a static website on Cloud Storage bucket for a domain you own behind a CDN .



The ressources that will be created in your project:

- An external IP address  [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) [link](https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address#reserve_new_static)

- An entry in Cloud DNS to map the IP address to the domain name [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) [link](https://cloud.google.com/dns/docs/tutorials/create-domain-tutorial#set-up-domain)
- A GCS bucket [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) [link](https://cloud.google.com/storage/docs/hosting-static-website)
- A https external load balancer with CDN  [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) [link](https://cloud.google.com/load-balancing/docs/https) 
- A http external load balancer to redirect HTTP traffic to HTTPS [link]()  [link](https://cloud.google.com/cdn/docs/setting-up-http-https-redirect#partial-http-lb)
- A managed certificate for HTTPS [link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) [link](https://cloud.google.com/load-balancing/docs/ssl-certificates/google-managed-certs)





#### Usage

You can go to the examples folder, however the usage of the module could be like this in your own main.tf file:

```hcl
module "cdn" {
  source  = "Ahmed-Amine-Soltani/cdn/gcp"
  version = "1.0.0"
  dns_name                     = var.dns_name
  google_dns_managed_zone_name = var.google_dns_managed_zone_name
  google_storage_bucket        = var.google_storage_bucket
}
```

Then perform the following commands on the root folder:

- [`terraform init`](#terraform init) to get the plugins

- [`terraform plan`](#terraform plan) to see the infrastructure plan

- [`terraform apply`](#terraform apply) to apply the infrastructure build

- [`terraform destroy`](#terraform destroy) to destroy the built infrastructure

  

##### Inputs

------

| Name                         | Description | Type     | Required |
| :--------------------------- | ----------- | -------- | -------- |
| dns_name                     | string      | `string` | yes      |
| google_dns_managed_zone_name | string      | `string` | yes      |
| google_storage_bucket        | string      | `string` | yes      |

##### Outputs

------

| Name                  | Description |
| --------------------- | ----------- |
| dns_managed_zone_name |             |
| lb_fqdn               |             |



##### Requirements

------

Before starting you’ll need some pre-existing configurations:

- An existing GCP account linked to a billing account
- An existing GCP project
- A service account with a key
- Terraform installed and configured on your machine
- A domain name managed in Cloud DNS (Public Zone)
- Domain named bucket [verification](https://cloud.google.com/storage/docs/domain-name-verification)
- Some files to upload to the bucket , least an index page `index.html`and a 404 page `404.html`.



##### Enable API's

------

In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:

