resource "kubernetes_service_account" "app_service_account" {
  depends_on = [kubernetes_namespace.kafka]

  metadata {
    name        = "app-service-account"
    namespace   = kubernetes_namespace.kafka.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = "google-app-service-account@training-386613.iam.gserviceaccount.com"
    }
  }

  automount_service_account_token = true
}
