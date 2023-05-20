resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

# resource "kubernetes_service" "kafka_service" {
#   metadata {
#     name      = "kafka-external"
#     namespace = kubernetes_namespace.kafka.metadata[0].name
#   }

#   spec {
#     selector = {
#       app = "kafka"
#     }

#     port {
#       port        = 9092
#       target_port = 9092
#     }

#     type = "LoadBalancer"

#     load_balancer_ip = local.ip_address
#   }
# }
