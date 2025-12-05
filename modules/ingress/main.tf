resource "kubernetes_ingress_v1" "unified_ingress" {
  metadata {
    name      = "unified-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = var.ingress_ip_name
      "cert-manager.io/cluster-issuer"              = "letsencrypt-prod"
      "kubernetes.io/ingress.class"                 = "gce"
    }
  }

  spec {

    rule {
      host = "grafana-${var.username}.${var.domain}"
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "monitoramento-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "shop-${var.username}.${var.domain}"
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "headlamp-${var.username}.${var.domain}"
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "headlamp"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    # rule {
    #   host = "keycloak.${var.username}.${var.domain}"
    #   http {
    #     path {
    #       path = "/*"
    #       backend {
    #         service {
    #           name = "keycloak"
    #           port {
    #             number = 80
    #           }
    #         }
    #       }
    #     }
    #   }
    # }

    tls {
      secret_name = "grafana-tls"
      hosts       = ["grafana-${var.username}.${var.domain}"]
    }

    tls {
      secret_name = "shop-tls"
      hosts       = ["shop-${var.username}.${var.domain}"]
    }

    tls {
      secret_name = "headlamp-tls"
      hosts       = ["headlamp-${var.username}.${var.domain}"]
    }

    # tls {
    #   secret_name = "keycloak-tls"
    #   hosts       = ["keycloak.${var.username}.${var.domain}"]
    # }
  }
}
