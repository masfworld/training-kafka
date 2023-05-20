data "google_client_config" "provider" {}

data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
  project  = data.google_client_config.provider.project
  depends_on = [google_container_cluster.primary]
}

resource "google_container_cluster" "primary" {
  name     = "training-cluster"
  location = "us-east1-b"
  network  = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}


resource "google_container_node_pool" "primary" {
  name       = "my-node-pool"
  location   = "us-east1-b"
  cluster    = google_container_cluster.primary.name

  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
