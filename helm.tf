module "onlineboutique" {
  source = "./modules/onlineboutique"
}

module "cert_manager" {
  source = "./modules/cert-manager"

  cloudflare_api_token = var.cloudflare_api_token
  email                = var.email
}

module "monitoring" {
  source = "./modules/monitoring"

  username        = var.username
  domain          = var.domain
  grafana_ip_name = google_compute_global_address.grafana_ip.name

  depends_on = [module.cert_manager]
}
