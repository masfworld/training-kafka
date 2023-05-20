provider "google" {
  credentials = file("../training-386613-cc8e974b462e.json")
  project     = "training-386613"
  region      = "us-east1"
  zone        = "us-east1-b"
}
