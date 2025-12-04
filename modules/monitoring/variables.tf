variable "username" {
  description = "The username to be used in the subdomain"
  type        = string
}

variable "domain" {
  description = "The domain name"
  type        = string
}

variable "grafana_ip_name" {
  description = "The name of the global static IP for Grafana"
  type        = string
}
