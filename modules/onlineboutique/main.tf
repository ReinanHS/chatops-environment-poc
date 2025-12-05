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
    name  = "frontend.externalService"
    value = false
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


