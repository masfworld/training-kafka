resource "google_service_account" "sa" {
  account_id   = "google-app-service-account"
  display_name = "Google Application Service Account"
  project      = data.google_client_config.provider.project
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = [
    "serviceAccount:${data.google_client_config.provider.project}.svc.id.goog[kafka/app-service-account]"
    ]
}

resource "google_secret_manager_secret_iam_binding" "secret_binding" {
  secret_id = "BEARER_TOKEN" # replace with your secret name
  role      = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}
