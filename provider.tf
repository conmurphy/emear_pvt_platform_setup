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
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "1.0.16"
    }
  }
}

provider "tfe" {
  token    = var.tfcb_token
}

provider "github" {
  token = var.github_token
}



# data "terraform_remote_state" "iks" {
#   backend = "remote"
#   config = {
#     organization = var.tfe_organization_name
#     workspaces = {
#       name = "emear-pvt-iks"
#     }
#   }
# }

# locals {
#   kube_config = yamldecode(data.terraform_remote_state.iks.outputs.kube_config)
# }



provider "intersight" {
  apikey    = var.intersight_api_key
  secretkey = var.intersight_secret_key
  endpoint  = var.intersight_endpoint
}

data "intersight_kubernetes_cluster" "iks" {
  #name = "emear-pvt-iks-predeployed"
  name = var.iks_cluster_name

}

provider "kubernetes" {
  host                   = yamldecode(base64decode(data.intersight_kubernetes_cluster.iks.results[0].kube_config)).clusters[0].cluster.server
  cluster_ca_certificate = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.iks.results[0].kube_config)).clusters[0].cluster.certificate-authority-data)
  client_certificate     = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.iks.results[0].kube_config)).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.iks.results[0].kube_config)).users[0].user.client-key-data)
}  
