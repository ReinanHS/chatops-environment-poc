resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.19.1"
  create_namespace = true
  namespace        = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubernetes_secret_v1" "cloudflare_api_token_secret" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = "cert-manager"
  }

  data = {
    api-token = var.cloudflare_api_token
  }

  depends_on = [helm_release.cert_manager]
}

resource "helm_release" "cluster_issuer" {
  name       = "cluster-issuer"
  repository = "https://bedag.github.io/helm-charts"
  chart      = "raw"
  version    = "2.0.0"
  namespace  = "cert-manager"

  values = [
    yamlencode({
      resources = [
        {
          apiVersion = "cert-manager.io/v1"
          kind       = "ClusterIssuer"
          metadata = {
            name = "letsencrypt-prod"
          }
          spec = {
            acme = {
              server = "https://acme-v02.api.letsencrypt.org/directory"
              email  = var.email
              privateKeySecretRef = {
                name = "letsencrypt-prod"
              }
              solvers = [
                {
                  dns01 = {
                    cloudflare = {
                      email = var.email
                      apiTokenSecretRef = {
                        name = "cloudflare-api-token-secret"
                        key  = "api-token"
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      ]
    })
  ]

  depends_on = [helm_release.cert_manager]
}
