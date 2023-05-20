data "terraform_remote_state" "primary" {
  backend = "local"
  config = {
    path = "../gks/terraform.tfstate"
  }
}

locals {
  kubeconfig = {
    host                   = "https://${data.terraform_remote_state.primary.outputs.cluster_endpoint}"
    token                  = data.terraform_remote_state.primary.outputs.access_token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.primary.outputs.cluster_ca_certificate)
  }
  ip_address = data.terraform_remote_state.primary.outputs.kafka_static_ip
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




