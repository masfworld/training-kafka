locals {
  kubeconfig = {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

provider "google" {
  credentials = file("./training-386613-cc8e974b462e.json")
  project     = "training-386613"
  region      = "us-east1"
  zone        = "us-east1-b"
}

provider "kubernetes" {
  host                   = local.kubeconfig.host
  token                  = local.kubeconfig.token
  cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = local.kubeconfig.host
    token                  = local.kubeconfig.token
    cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
  }
}




