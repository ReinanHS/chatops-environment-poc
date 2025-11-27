resource "helm_release" "onlineboutique" {
  name       = "onlineboutique"
  repository = "oci://us-docker.pkg.dev/online-boutique-ci/charts"
  chart      = "onlineboutique"
  version    = "0.10.4"
}
