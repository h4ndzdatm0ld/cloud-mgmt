terraform {
  cloud {
    organization = "crunchy-org"
    workspaces {
      name = "crunchy-iac"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "do-dev-sf03" {
  image      = "ubuntu-22-04-x64"
  name       = "do-dev-sfo3"
  region     = "sfo3"
  size       = "s-1vcpu-1gb"
  backups    = true
  monitoring = true
  ipv6       = true
  ssh_keys   = ["34383489"]
}