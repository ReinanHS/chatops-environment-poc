resource "helm_release" "grafana_backend_config" {
  name             = "grafana-backend-config"
  repository       = "https://bedag.github.io/helm-charts"
  chart            = "raw"
  version          = "2.0.0"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    yamlencode({
      resources = [
        {
          apiVersion = "cloud.google.com/v1"
          kind       = "BackendConfig"
          metadata = {
            name      = "monitoramento-grafana-bc"
            namespace = "monitoring"
          }
          spec = {
            healthCheck = {
              checkIntervalSec   = 15
              timeoutSec         = 15
              healthyThreshold   = 1
              unhealthyThreshold = 2
              type               = "HTTP"
              requestPath        = "/api/health"
              port               = 3000
            }
          }
        }
      ]
    })
  ]
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "monitoramento"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "79.11.0"
  create_namespace = true
  namespace        = "monitoring"

  depends_on = [
    helm_release.grafana_backend_config
  ]

  values = [
    yamlencode({

      prometheus = {
        prometheusSpec = {
          scrapeInterval = "15s"
        }
      }

      grafana = {
        enabled       = true
        adminPassword = "admin"

        service = {
          type = "NodePort"
          annotations = {
            "cloud.google.com/backend-config" = "{\"default\": \"monitoramento-grafana-bc\"}"
          }
        }

        ingress = {
          enabled          = true
          ingressClassName = "gce"
          annotations = {
            "kubernetes.io/ingress.global-static-ip-name" = var.grafana_ip_name
            "cert-manager.io/cluster-issuer"              = "letsencrypt-prod"
            "kubernetes.io/ingress.class"                 = "gce"
          }
          hosts = ["grafana.${var.username}.${var.domain}"]
          tls = [{
            secretName = "grafana-tls"
            hosts      = ["grafana.${var.username}.${var.domain}"]
          }]
        }

        plugins = ["redis-datasource"]

        dashboardProviders = {
          "dashboardproviders.yaml" = {
            apiVersion = 1
            providers = [
              {
                name            = "Redis"
                orgId           = 1
                folder          = ""
                type            = "file"
                disableDeletion = false
                editable        = true
                options = {
                  path = "/var/lib/grafana/plugins/redis-datasource/dashboards"
                }
              },
            ]
          }
        }

        additionalDataSources = [
          {
            name   = "Redis"
            type   = "redis-datasource"
            url    = "redis://redis-cart.default.svc.cluster.local:6379"
            access = "proxy"
            jsonData = {
              client = "standalone"
            }
          }
        ]
      }
    })
  ]
}
