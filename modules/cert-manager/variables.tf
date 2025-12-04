variable "cloudflare_api_token" {
  description = "The Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "email" {
  description = "Email address for Let's Encrypt registration"
  type        = string
}
