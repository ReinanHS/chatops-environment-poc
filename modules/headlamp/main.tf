resource "helm_release" "headlamp" {
  name       = "headlamp"
  repository = "https://kubernetes-sigs.github.io/headlamp/"
  chart      = "headlamp"
  namespace  = "default"

  set {
    name  = "ingress.enabled"
    value = "false"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "kubernetes_service_account_v1" "headlamp_admin" {
  metadata {
    name      = "headlamp-admin"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role_binding_v1" "headlamp_admin" {
  metadata {
    name = "headlamp-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.headlamp_admin.metadata[0].name
    namespace = kubernetes_service_account_v1.headlamp_admin.metadata[0].namespace
  }
}

resource "kubernetes_secret_v1" "headlamp_admin" {
  metadata {
    name      = "headlamp-admin-token"
    namespace = "default"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.headlamp_admin.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}
