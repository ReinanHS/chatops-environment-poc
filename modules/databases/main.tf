resource "kubernetes_namespace_v1" "databases" {
  metadata {
    name = "databases"
  }
}

resource "kubernetes_config_map_v1" "mariadb_init" {
  metadata {
    name      = "mariadb-init-scripts"
    namespace = kubernetes_namespace_v1.databases.metadata[0].name
  }

  data = {
    "01-init-extra.sql" = <<-EOF
      CREATE DATABASE IF NOT EXISTS keycloak;
      CREATE USER IF NOT EXISTS 'keycloak'@'%' IDENTIFIED BY 'keycloak-password';
      GRANT ALL PRIVILEGES ON keycloak.* TO 'keycloak'@'%';

      CREATE DATABASE IF NOT EXISTS uptime_kuma;
      CREATE USER IF NOT EXISTS 'uptime_kuma'@'%' IDENTIFIED BY 'uptime-kuma-password';
      GRANT ALL PRIVILEGES ON uptime_kuma.* TO 'uptime_kuma'@'%';

      FLUSH PRIVILEGES;
    EOF
  }
}

resource "kubernetes_config_map_v1" "postgres_init" {
  metadata {
    name      = "postgres-init-scripts"
    namespace = kubernetes_namespace_v1.databases.metadata[0].name
  }

  data = {
    "01-init-n8n.sql" = <<-EOF
      CREATE USER n8n WITH PASSWORD 'n8n-password';
      CREATE DATABASE n8n;
      GRANT ALL PRIVILEGES ON DATABASE n8n TO n8n;
    EOF
  }
}

resource "helm_release" "mariadb" {
  name             = "mariadb"
  repository       = "oci://registry-1.docker.io/cloudpirates"
  chart            = "mariadb"
  namespace        = kubernetes_namespace_v1.databases.metadata[0].name
  create_namespace = false
  version          = "0.8.0"

  set {
    name  = "initdbScriptsConfigMap"
    value = kubernetes_config_map_v1.mariadb_init.metadata[0].name
  }

  set {
    name  = "auth.rootPassword"
    value = var.mariadb_root_password
  }

  set {
    name  = "auth.database"
    value = var.mariadb_database
  }

  set {
    name  = "auth.username"
    value = var.mariadb_user
  }

  set {
    name  = "auth.password"
    value = var.mariadb_user_password
  }
}

resource "helm_release" "postgres" {
  name             = "postgres"
  repository       = "oci://registry-1.docker.io/cloudpirates"
  chart            = "postgres"
  namespace        = kubernetes_namespace_v1.databases.metadata[0].name
  create_namespace = false
  version          = "0.12.4"

  set {
    name  = "initdb.scriptsConfigMap"
    value = kubernetes_config_map_v1.postgres_init.metadata[0].name
  }

  set {
    name  = "auth.database"
    value = var.postgres_database
  }

  set {
    name  = "auth.username"
    value = var.postgres_user
  }

  set {
    name  = "auth.password"
    value = var.postgres_user_password
  }
}

resource "helm_release" "phpmyadmin" {
  name             = "phpmyadmin"
  repository       = "https://charts.alekc.dev"
  chart            = "phpmyadmin"
  namespace        = "default"
  create_namespace = false
  version          = "0.2.2"

  depends_on = [
    helm_release.mariadb
  ]

  set {
    name  = "config.PMA_HOSTS"
    value = "mariadb.databases.svc.cluster.local"
  }

  set {
    name  = "config.PMA_ABSOLUTE_URI"
    value = "https://phpmyadmin-${var.username}.${var.domain}/"
  }
}
