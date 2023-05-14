resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }

  depends_on = [
    google_container_node_pool.primary,
  ]
}

resource "kubernetes_service" "kafka_service" {
  metadata {
    name      = "kafka-external"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }

  spec {
    selector = {
      app = "kafka"
    }

    port {
      port        = 9092
      target_port = 9092
    }

    type = "LoadBalancer"

    load_balancer_ip = google_compute_address.kafka_static_ip.address
  }

  depends_on = [
    google_container_node_pool.primary,
  ]
}
