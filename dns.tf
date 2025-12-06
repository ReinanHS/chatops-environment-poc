data "cloudflare_zone" "domain" {
  name = var.domain
}

resource "cloudflare_record" "ingress_ip" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "grafana-${var.username}"
  content = google_compute_global_address.ingress_ip.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "shop" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "shop-${var.username}"
  content = google_compute_global_address.ingress_ip.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "headlamp" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "headlamp-${var.username}"
  content = google_compute_global_address.ingress_ip.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "status" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "status-${var.username}"
  content = google_compute_global_address.ingress_ip.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "uptime-kuma" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "uptime-kuma-${var.username}"
  content = google_compute_global_address.ingress_ip.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "phpmyadmin" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "phpmyadmin-${var.username}"
  content = google_compute_global_address.ingress_ip.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "n8n" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "n8n-${var.username}"
  content = google_compute_global_address.ingress_ip.address
  type    = "A"
  proxied = true
}
