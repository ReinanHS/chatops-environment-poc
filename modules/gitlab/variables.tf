variable "domain" {
  description = "Domain name"
  type        = string
}

variable "username" {
  description = "Username to append to subdomains"
  type        = string
}

variable "gitlab_edition" {
  description = "GitLab edition to install (ce or ee)"
  type        = string
  default     = "ce"
}
