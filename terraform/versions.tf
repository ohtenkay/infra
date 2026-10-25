terraform {
  required_version = ">= 1.16.0, < 2.0.0"

  cloud {
    organization = "ohtenkay_infra"

    workspaces {
      name = "servnix"
    }
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.70.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# The token is supplied through HCLOUD_TOKEN, never through Terraform variables.
provider "hcloud" {}
