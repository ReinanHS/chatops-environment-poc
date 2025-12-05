variable "username" {
  description = "The username to be used in the subdomain"
  type        = string
}

variable "domain" {
  description = "The domain name"
  type        = string
}

variable "ingress_ip_name" {
  description = "The name of the global static IP for the ingress"
  type        = string
}
