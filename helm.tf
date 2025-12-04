resource "helm_release" "onlineboutique" {
  name       = "onlineboutique"
  repository = "oci://us-docker.pkg.dev/online-boutique-ci/charts"
  chart      = "onlineboutique"
  version    = "0.10.4"
  timeout    = 900
  wait       = true

  set {
    name  = "adService.resources.requests.cpu"
    value = "60m"
  }
  set {
    name  = "adService.resources.requests.memory"
    value = "54Mi"
  }

  set {
    name  = "cartService.resources.requests.cpu"
    value = "60m"
  }
  set {
    name  = "cartService.resources.requests.memory"
    value = "39Mi"
  }

  set {
    name  = "checkoutService.resources.requests.cpu"
    value = "30m"
  }
  set {
    name  = "checkoutService.resources.requests.memory"
    value = "20Mi"
  }

  set {
    name  = "currencyService.resources.requests.cpu"
    value = "30m"
  }
  set {
    name  = "currencyService.resources.requests.memory"
    value = "39Mi"
  }

  set {
    name  = "emailService.resources.requests.cpu"
    value = "30m"
  }
  set {
    name  = "emailService.resources.requests.memory"
    value = "20Mi"
  }

  set {
    name  = "frontend.resources.requests.cpu"
    value = "30m"
  }
  set {
    name  = "frontend.resources.requests.memory"
    value = "20Mi"
  }

  set {
    name  = "loadGenerator.resources.requests.cpu"
    value = "90m"
  }
  set {
    name  = "loadGenerator.resources.requests.memory"
    value = "77Mi"
  }

  set {
    name  = "paymentService.resources.requests.cpu"
    value = "30m"
  }
  set {
    name  = "paymentService.resources.requests.memory"
    value = "39Mi"
  }

  set {
    name  = "productCatalogService.resources.requests.cpu"
    value = "30m"
  }
  set {
    name  = "productCatalogService.resources.requests.memory"
    value = "20Mi"
  }

  set {
    name  = "recommendationService.resources.requests.cpu"
    value = "30m"
  }
  set {
    name  = "recommendationService.resources.requests.memory"
    value = "66Mi"
  }

  set {
    name  = "shippingService.resources.requests.cpu"
    value = "30m"
  }

  set {
    name  = "shippingService.resources.requests.memory"
    value = "20Mi"
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.12.0"
  create_namespace = true
  namespace        = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}


resource "kubernetes_secret" "cloudflare_api_token_secret" {
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

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "7.3.0"
  create_namespace = true
  namespace        = "monitoring"

  set {
    name  = "adminPassword"
    value = "admin"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.hosts[0]"
    value = "grafana.${var.username}.${var.domain}"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
    value = google_compute_global_address.grafana_ip.name
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "gce"
  }

  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "grafana.${var.username}.${var.domain}"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "grafana-tls"
  }

  depends_on = [helm_release.cluster_issuer]
}
