resource "kubernetes_namespace" "kafka" {
  metadata {
    annotations = {
      "iam.gke.io/gcp-service-account" = data.terraform_remote_state.primary.outputs.google_service_account_sa_email
    }
    name = "kafka"
  }
}
