terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "0.26.1"
    }
    github = {
      source = "integrations/github"
      version = "4.12.2"
    }
     kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.5.0"
    }
  }
}

provider "tfe" {
  token    = var.tfcb_token
}

provider "github" {
  token = var.github_token
}

data "intersight_kubernetes_cluster" "iks" {
  name = "emear-pvt-iks"
}

data "terraform_remote_state" "iks" {
  backend = "remote"
  config = {
    organization = var.tfe_organization_name
    workspaces = {
      name = "emear-pvt-iks"
    }
  }
}


provider "kubernetes" {
  # host = var.kubernetes_host
  # token = var.kubernetes_token
  host                   = yamldecode(base64decode(data.terraform_remote_state.iks.kube_config.0.kube_config)).clusters.0.cluster.server
  cluster_ca_certificate = base64decode(yamldecode(base64decode(data.terraform_remote_state.iks.kube_config.0.kube_config)).clusters.0.cluster.certificate-authority-data)
  client_certificate     = base64decode(yamldecode(base64decode(data.terraform_remote_state.iks.kube_config.0.kube_config)).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(base64decode(data.terraform_remote_state.iks.kube_config.0.kube_config)).users[0].user.client-key-data)
}
