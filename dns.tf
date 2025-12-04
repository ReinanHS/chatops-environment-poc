resource "google_compute_global_address" "grafana_ip" {
  name = "grafana-ip"
}

resource "google_compute_global_address" "shop_ip" {
  name = "shop-ip"
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

resource "cloudflare_record" "shop" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "shop.${var.username}"
  content = google_compute_global_address.shop_ip.address
  type    = "A"
  proxied = false
}
