variable "awsprops" {
    type = map(string)
    default = {
    region = "us-west-1"
    ami = "ami-01f87c43e618bf8f0"
    itype = "t2.micro"
    publicip = true
  }
}

# terraform {
#   backend "local" {
#     path = "./terraform-plans/simple-ec2/terraform.tfstate"
#   }
# }

provider "aws" {
  region = lookup(var.awsprops, "region")
}

resource "aws_security_group" "project-iac-sg" {

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "project-iac" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  associate_public_ip_address = lookup(var.awsprops, "publicip")


  vpc_security_group_ids = [
    aws_security_group.project-iac-sg.id
  ]

  tags = {
    Name = "Test-Ubuntu-TF"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.project-iac-sg ]
}


output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}
