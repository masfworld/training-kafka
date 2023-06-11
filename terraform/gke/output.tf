output "cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "The endpoint of the primary container cluster"
  sensitive = true
}

output "cluster_ca_certificate" {
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  description = "The cluster CA certificate of the primary container cluster"
}

output "access_token" {
  value       = data.google_client_config.provider.access_token
  description = "The access token for the Google provider"
  sensitive = true
}

output "kafka_static_ip" {
  value       = google_compute_address.kafka_static_ip.address
  description = "The static IP for Kafka"
}

output "google_service_account_sa_email" {
  value       = google_service_account.sa.email
  description = "The static IP for Kafka"
}
