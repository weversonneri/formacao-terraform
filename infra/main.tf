terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region_aws
}

resource "aws_instance" "app_server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  # user_data     = <<-EOF
  #               #!/bin/bash
  #               cd /home/ubuntu
  #               echo "<h1>Feito pelo terraform</h1>" > index.html
  #               nohup busybox httpd -f -p 8080 &
  #               EOF
  tags = {
    Name = "terraform-ansible-python"
  }
  # security_groups = ["${aws_security_group.acesso_geral}"]
  vpc_security_group_ids = ["${aws_security_group.acesso_geral.id}"] //link de security group na instancia, com id do group
}


resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = file("${var.key_name}.pub")
}

output "ip_publico" {
  value = aws_instance.app_server.public_ip
}
