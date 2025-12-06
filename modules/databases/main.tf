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
