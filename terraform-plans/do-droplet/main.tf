resource "digitalocean_droplet" "nautobot-apps" {
  count  = length(var.roster)
  name   = "nautobot-apps-${var.roster[count.index]}"
  image  = "101018962"
  region = "nyc3"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.devpop.id
  ]
  user_data = file("data/nautobot-droplets.yml")
  
  // provisioner "remote-exec" {
  //   inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

  //   connection {
  //     host        = self.ipv4_address
  //     type        = "ssh"
  //     user        = "root"
  //     private_key = file(var.PVT_KEY)
  //   }
  // }

  // provisioner "local-exec" {
  //   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.PVT_KEY} -e 'pub_key=${var.PUB_KEY}' baseline-configuration.yml"
  // }
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.nautobot-apps :
    droplet.name => droplet.ipv4_address
  }
}
