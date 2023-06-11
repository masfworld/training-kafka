provider "google" {
  credentials = file("../credentials.json")
  project     = "training-386613"
  region      = "us-east1"
  zone        = "us-east1-b"
}
