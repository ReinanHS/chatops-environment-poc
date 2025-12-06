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

    rule {
      host = "status-${var.username}.${var.domain}"
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "uptime-kuma"
              port {
                number = 3001
              }
            }
          }
        }
      }
    }

    rule {
      host = "uptime-kuma-${var.username}.${var.domain}"
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "uptime-kuma"
              port {
                number = 3001
              }
            }
          }
        }
      }
    }

    rule {
      host = "phpmyadmin-${var.username}.${var.domain}"
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "phpmyadmin"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

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

    tls {
      secret_name = "uptime-kuma-tls"
      hosts       = ["uptime-kuma-${var.username}.${var.domain}"]
    }

    tls {
      secret_name = "status-tls"
      hosts       = ["status-${var.username}.${var.domain}"]
    }

    tls {
      secret_name = "phpmyadmin-tls"
      hosts       = ["phpmyadmin-${var.username}.${var.domain}"]
    }
  }
}
