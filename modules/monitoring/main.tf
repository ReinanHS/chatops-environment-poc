resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "27.49.0"
  create_namespace = true
  namespace        = "monitoring"

  set {
    name  = "server.global.scrape_interval"
    value = "15s"
  }
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "10.3.0"
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
    value = var.grafana_ip_name
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

  values = [
    yamlencode({
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
            }
          ]
        }
      }
      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              type      = "prometheus"
              url       = "http://prometheus-server.monitoring.svc.cluster.local"
              access    = "proxy"
              isDefault = true
            },
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
      }
    })
  ]
}
