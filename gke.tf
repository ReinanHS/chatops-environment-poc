resource "time_static" "cluster_creation" {}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  enable_autopilot = true

  deletion_protection = false

  resource_labels = {
    environment   = "lab"
    cost_category = "low"
    created_at    = replace(replace(replace(lower(time_static.cluster_creation.rfc3339), ":", "-"), "t", "-"), "z", "")
    expires_at    = replace(replace(replace(lower(timeadd(time_static.cluster_creation.rfc3339, "1h")), ":", "-"), "t", "-"), "z", "")
  }
}
