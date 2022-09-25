terraform {
  required_version = "~> 1.3.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "do-dev-tf" {
  image     = "ubuntu-18-04-x64"
  name      = "do-dev-tf"
  region    = "sfo3"
  size      = "s-1vcpu-1gb"
  # user_data = file("terramino_app.yaml")
}