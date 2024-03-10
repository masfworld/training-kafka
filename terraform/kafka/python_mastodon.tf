resource "kubernetes_deployment" "python_mastodon_kafka_producer" {
  depends_on = [helm_release.kafka]

  metadata {
    name = "python-mastodon-kafka"
    namespace  = kubernetes_namespace.kafka.metadata[0].name
    labels = {
      App = "python-mastodon-kafka"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "python-mastodon-kafka"
      }
    }

    template {
      metadata {
        labels = {
          App = "python-mastodon-kafka"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.app_service_account.metadata[0].name  # specify the service account

        container {
          image = "masfworld/python-mastodon-kafka:0.1"
          name  = "python-mastodon-kafka"

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
