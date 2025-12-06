resource "helm_release" "mariadb" {
  name             = "mariadb"
  repository       = "oci://registry-1.docker.io/cloudpirates"
  chart            = "mariadb"
  namespace        = "databases"
  create_namespace = true
  version          = "0.8.0"

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
  namespace        = "databases"
  create_namespace = true
  version          = "0.12.4"

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
