# Networking
resource "google_compute_network" "vpc" {
  name                    = "my-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-east1"
  network       = google_compute_network.vpc.name
}

resource "google_compute_address" "kafka_static_ip" {
  name   = "kafka-static-ip"
  region = "us-east1"
}
