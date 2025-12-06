resource "helm_release" "gitlab" {
  name       = "gitlab"
  repository = "https://charts.gitlab.io"
  chart      = "gitlab"
  version    = "9.6.1"
  timeout    = 600

  values = [
    <<EOF
    global:
      edition: ${var.gitlab_edition}
      hosts:
        domain: ${var.domain}
        https: false
      ingress:
        configureCertmanager: false
        enabled: false
        class: none
      psql:
        password:
          secret: gitlab-postgresql-password
          key: postgresql-password
      minio:
        enabled: true

    installCertmanager: false
    certmanager:
      installCRDs: false

    nginx-ingress:
      enabled: false

    prometheus:
      install: false

    gitlab-runner:
      install: false

    gitlab:
      webservice:
        service:
          annotations:
            cloud.google.com/backend-config: '{"default": "gitlab-backend-config"}'
        minReplicas: 1
        maxReplicas: 1
        resources:
          requests:
            memory: 1Gi
            cpu: 500m
          limits:
            memory: 2Gi
            cpu: 1000m
      sidekiq:
        minReplicas: 1
        maxReplicas: 1
        resources:
          requests:
            memory: 500Mi
            cpu: 200m
      gitlab-shell:
        minReplicas: 1
        maxReplicas: 1
      toolbox:
        enabled: true
      kas:
        enabled: false
      gitaly:
        persistence:
          size: 5Gi

    registry:
      enabled: false

    minio:
      persistence:
        size: 5Gi

postgresql:
  image:
    tag: 13.6.0
  persistence:
    size: 5Gi

redis:
  master:
    persistence:
      size: 2Gi
EOF
  ]
}
