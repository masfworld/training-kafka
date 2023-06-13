resource "kubernetes_deployment" "python_kafka_producer_inspections" {
  depends_on = [helm_release.kafka]

  metadata {
    name = "python-inspections-kafka"
    namespace  = kubernetes_namespace.kafka.metadata[0].name
    labels = {
      App = "python-inspections-kafka"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "python-inspections-kafka"
      }
    }

    template {
      metadata {
        labels = {
          App = "python-inspections-kafka"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.app_service_account.metadata[0].name  # specify the service account

        container {
          image = "masfworld/python-inspections-kafka:latest"
          name  = "python-inspections-kafka"

          image_pull_policy = "Always"

          env {
            name  = "KAFKA_BOOTSTRAP_SERVER"
            value = "kafka:9092"  # or your actual Kafka service name
          }
        }
      }
    }
  }
}
