packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "build_name" {
  type    = string
  default = "github-runner"
}

locals {
  ubuntu_version = "20.04"
  owner          = "hugotinoco@icloud.com"
}

source "amazon-ebs" "github-runner-ami" {
  ami_name = "Github Runner (Ubuntu 20.10 ${lower(regex_replace(timestamp(), ":", "-"))})"
  ami_regions = [
    "us-west-1",
  ]
  associate_public_ip_address = true
  communicator                = "ssh"
  ena_support                 = true
  instance_type               = "t3.micro"
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_type           = "gp3"
  }
  region             = "us-west-1"
  security_group_ids = ["sg-0f62c0f985447c073"]
  shutdown_behavior  = "terminate"
  snapshot_tags = {
    "UbuntuVersion" = local.ubuntu_version
    "Owner"         = local.owner
    "Name"          = "Github Runer AMI Snapshot"
  }
  source_ami    = "ami-01f87c43e618bf8f0"
  ssh_interface = "public_ip"
  ssh_username  = "ubuntu"
  subnet_id     = "subnet-c3884ba5"
  tags = {
    "UbuntuVersion" = local.ubuntu_version
    "Owner"         = local.owner
    "Name"          = "Github Runner AMI"
  }
  temporary_key_pair_type = "ed25519"
  vpc_id                  = "vpc-7bb9a81c"

}

build {
  sources = ["source.amazon-ebs.github-runner-ami"]

  provisioner "shell" {
    script = "packer-ami/github-runner/scripts/runner/docker.sh"
  }
  provisioner "shell" {
    script = "packer-ami/github-runner/scripts/runner/docker-compose.sh"
  }
  provisioner "shell" {
    script = "packer-ami/github-runner/scripts/runner/python-utils.sh"
  }
}
