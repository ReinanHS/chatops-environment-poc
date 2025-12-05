resource "time_static" "cluster_creation" {}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    spot         = true
    disk_type    = "pd-standard"
    disk_size_gb = 20
  }

  deletion_protection = false

  resource_labels = {
    environment   = "lab"
    cost_category = "low"
    created_at    = replace(replace(replace(lower(time_static.cluster_creation.rfc3339), ":", "-"), "t", "-"), "z", "")
    expires_at    = replace(replace(replace(lower(timeadd(time_static.cluster_creation.rfc3339, "1h")), ":", "-"), "t", "-"), "z", "")
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = "spot-node-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    spot         = true
    machine_type = "e2-standard-2"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    disk_size_gb = 20
    disk_type    = "pd-standard"
  }
}

resource "google_compute_global_address" "ingress_ip" {
  name = "ingress-ip"
}
