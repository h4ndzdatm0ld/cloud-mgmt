terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "DO_TOKEN" {
  type        = string
  description = "Digital Ocean API Token"
}

variable "PVT_KEY" {
  type        = string
  description = "Private Key Location"
  default     = "../../keys/id_rsa"
}

variable "PUB_KEY" {
  type        = string
  description = "Public Key Location"
  default     = "../../keys/id_rsa.pub"
}

provider "digitalocean" {
  token = var.DO_TOKEN
}

data "digitalocean_ssh_key" "devpop" {
  name = "devpop"
}

variable "roster" {
  description = "Create Droplet from student names"
  type        = list(string)
  default     = ["htinoco", "gmuller"]
}