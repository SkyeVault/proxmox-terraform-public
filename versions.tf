terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }

  cloud {
    organization = "Org Name"
    workspaces {
      name = "test-workspace-name"
    }
  }
}
