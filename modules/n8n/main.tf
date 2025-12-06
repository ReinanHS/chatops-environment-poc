resource "helm_release" "n8n_backend_config" {
  name             = "n8n-backend-config"
  repository       = "https://bedag.github.io/helm-charts"
  chart            = "raw"
  version          = "2.0.0"
  namespace        = "default"
  create_namespace = false

  values = [
    yamlencode({
      resources = [
        {
          apiVersion = "cloud.google.com/v1"
          kind       = "BackendConfig"
          metadata = {
            name      = "n8n-bc"
            namespace = "default"
          }
          spec = {
            healthCheck = {
              checkIntervalSec   = 15
              timeoutSec         = 15
              healthyThreshold   = 1
              unhealthyThreshold = 2
              type               = "HTTP"
              requestPath        = "/healthz"
              port               = 5678
            }
          }
        }
      ]
    })
  ]
}

resource "helm_release" "n8n" {
  name             = "n8n"
  repository       = "https://community-charts.github.io/helm-charts"
  chart            = "n8n"
  create_namespace = false
  namespace        = "default"
  version          = "1.16.8"

  depends_on = [
    helm_release.n8n_backend_config
  ]

  values = [
    yamlencode({
      service = {
        type = "NodePort"
        port = 5678
        annotations = {
          "cloud.google.com/backend-config" = "{\"default\": \"n8n-bc\"}"
        }
      }
      ingress = {
        enabled = false
      }
      db = {
        type = "postgresdb"
      }
      externalPostgresql = {
        host     = var.postgres_host
        port     = var.postgres_port
        database = var.postgres_database
        username = var.postgres_user
        password = var.postgres_password
      }
      externalRedis = {
        host = var.redis_host
        port = var.redis_port
      }
      webhook = {
        url = "https://webhook-reinanhs.labchatops.online/"
      }
    })
  ]
}
