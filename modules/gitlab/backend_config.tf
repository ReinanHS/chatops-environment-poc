resource "kubernetes_manifest" "gitlab_backend_config" {
  manifest = {
    apiVersion = "cloud.google.com/v1"
    kind       = "BackendConfig"
    metadata = {
      name      = "gitlab-backend-config"
      namespace = "default"
    }
    spec = {
      healthCheck = {
        checkIntervalSec   = 15
        timeoutSec         = 15
        healthyThreshold   = 1
        unhealthyThreshold = 2
        type               = "HTTP"
        requestPath        = "/-/readiness"
        port               = 8181
      }
    }
  }
}
