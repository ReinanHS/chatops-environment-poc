resource "google_compute_global_address" "grafana_ip" {
  name = "grafana-ip"
}

data "cloudflare_zone" "domain" {
  name = var.domain
}

resource "cloudflare_record" "grafana" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "grafana.${var.username}"
  content = google_compute_global_address.grafana_ip.address
  type    = "A"
  proxied = false
}
