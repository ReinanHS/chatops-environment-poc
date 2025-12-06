module "onlineboutique" {
  source = "./modules/onlineboutique"

  username = var.username
  domain   = var.domain
}

module "cert_manager" {
  source = "./modules/cert-manager"

  cloudflare_api_token = var.cloudflare_api_token
  email                = var.email

  depends_on = [google_container_node_pool.primary_preemptible_nodes]
}

module "monitoring" {
  source = "./modules/monitoring"

  username = var.username
  domain   = var.domain

  depends_on = [module.cert_manager]
}

module "ingress" {
  source = "./modules/ingress"

  username        = var.username
  domain          = var.domain
  ingress_ip_name = google_compute_global_address.ingress_ip.name

  depends_on = [
    module.monitoring,
    module.onlineboutique,
    module.headlamp
  ]
}

module "headlamp" {
  source = "./modules/headlamp"

  depends_on = [module.cert_manager, google_container_node_pool.primary_preemptible_nodes]
}

# module "keycloak" {
#   source = "./modules/keycloak"

#   depends_on = [module.cert_manager, google_container_node_pool.primary_preemptible_nodes]
# }

module "databases" {
  source = "./modules/databases"
}
