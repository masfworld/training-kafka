resource "helm_release" "kafka" {
  depends_on = [kubernetes_namespace.kafka]

  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "22.1.1"
  namespace  = kubernetes_namespace.kafka.metadata[0].name

  set {
    name  = "externalAccess.enabled"
    value = "true"
  }

  set {
    name  = "externalAccess.autoDiscovery.enabled"
    value = "false"
  }

  set {
    name  = "externalAccess.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "externalAccess.service.loadBalancerIPs[0]"
    value = local.ip_address
  }

  set {
    name  = "rbac.create"
    value = "true"
  }
}
