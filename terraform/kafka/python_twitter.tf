resource "kubernetes_deployment" "python_kafka_producer" {
  depends_on = [helm_release.kafka]

  metadata {
    name = "python-twitter-kafka"
    namespace  = kubernetes_namespace.kafka.metadata[0].name
    labels = {
      App = "python-twitter-kafka"
    }
  }

  spec {
    replicas = 0

    selector {
      match_labels = {
        App = "python-twitter-kafka"
      }
    }

    template {
      metadata {
        labels = {
          App = "python-twitter-kafka"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.app_service_account.metadata[0].name  # specify the service account

        container {
          image = "masfworld/python-twitter-kafka:0.1"
          name  = "python-twitter-kafka"

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
