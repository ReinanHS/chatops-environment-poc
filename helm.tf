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

module "databases" {
  source = "./modules/databases"

  username = var.username
  domain   = var.domain

  mariadb_database      = var.mariadb_database
  mariadb_user          = var.mariadb_user
  mariadb_user_password = var.mariadb_user_password
}

module "monitoring" {
  source = "./modules/monitoring"

  username = var.username
  domain   = var.domain

  mariadb_host          = "mariadb.databases.svc.cluster.local"
  mariadb_port          = 3306
  mariadb_database      = var.mariadb_database
  mariadb_user          = var.mariadb_user
  mariadb_user_password = var.mariadb_user_password

  depends_on = [module.cert_manager, module.databases]
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

module "n8n" {
  source = "./modules/n8n"

  username = var.username
  domain   = var.domain

  postgres_host     = "postgres.databases.svc.cluster.local"
  postgres_port     = 5432
  postgres_database = "n8n"
  postgres_user     = "n8n"
  postgres_password = "n8n-password"

  redis_host = "redis-cart.default.svc.cluster.local"
  redis_port = 6379

  depends_on = [module.cert_manager, module.databases, module.onlineboutique]
}
