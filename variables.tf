variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The default region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The default zone for resources"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "chatops-lab-cluster"
}

variable "cloudflare_api_token" {
  description = "The Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "username" {
  description = "The username to be used in the subdomain"
  type        = string
}

variable "domain" {
  description = "The domain name"
  type        = string
  default     = "labchatops.online"
}

variable "email" {
  description = "Email address for Let's Encrypt registration"
  type        = string
}
