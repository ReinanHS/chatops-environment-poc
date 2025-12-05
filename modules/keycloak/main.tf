resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "keycloak"
  namespace  = "default"

  set {
    name  = "auth.adminUser"
    value = "admin"
  }

  set {
    name  = "auth.adminPassword"
    value = "admin"
  }

  set {
    name  = "ingress.enabled"
    value = "false"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "httpRelativePath"
    value = "/"
  }

  set {
    name  = "image.tag"
    value = "26.0.0"
  }

  set {
    name  = "image.repository"
    value = "bitnamilegacy/keycloak"
  }

  timeout = 600
}
