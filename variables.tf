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
