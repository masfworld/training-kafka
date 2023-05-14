resource "helm_release" "kafka" {
  depends_on = [kubernetes_namespace.kafka]

  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "22.1.1"
  namespace  = kubernetes_namespace.kafka.metadata[0].name

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "externalAccess.enabled"
    value = "true"
  }

  set {
    name  = "externalAccess.service.port"
    value = "9092"
  }

  set {
    name  = "externalAccess.autoDiscovery.enabled"
    value = "false"
  }

  set {
    name  = "externalAccess.service.loadBalancerIPs[0]"
    value = google_compute_address.kafka_static_ip.address
  }
}
