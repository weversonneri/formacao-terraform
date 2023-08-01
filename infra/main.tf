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
  profile = "default"
  region  = var.region_aws
}

resource "aws_launch_template" "maquina" {
  image_id      = var.ami
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
  security_group_names = [var.security_group]
  user_data            = var.producao ? filebase64("ansible.sh") : ""
  # security_groups = ["${aws_security_group.acesso_geral}"]
  # vpc_security_group_ids = ["${aws_security_group.acesso_geral.id}"] //link de security group na instancia, com id do group
}


resource "aws_autoscaling_group" "autoscaling_group" {
  availability_zones = ["${var.region_aws}a", "${var.region_aws}b"]
  name               = var.group_name
  max_size           = var.max_size
  min_size           = var.min_size
  target_group_arns  = var.producao ? [aws_lb_target_group.load_balance_target[0].arn] : []
  launch_template {
    id      = aws_launch_template.maquina.id
    version = "$Latest"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = file("${var.key_name}.pub")
}

# output "ip_publico" {
#   value = aws_instance.app_server.public_ip
# }

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.region_aws}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.region_aws}b"
}

resource "aws_lb" "load_balancer" {
  internal        = false
  subnets         = [aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id]
  security_groups = [aws_security_group.acesso_geral.id]
  count           = var.producao ? 1 : 0
}
resource "aws_default_vpc" "vpc" {
}

resource "aws_lb_target_group" "load_balance_target" {
  name     = "load-balance-target"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.vpc.id
  count    = var.producao ? 1 : 0
}

resource "aws_lb_listener" "load_balancer_entry" {
  load_balancer_arn = aws_lb.load_balancer[0].arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load_balance_target[0].arn
  }
  count = var.producao ? 1 : 0
}

resource "aws_autoscaling_policy" "prod_scaling" {
  name                   = "terraform-scaling"
  autoscaling_group_name = var.group_name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  count = var.producao ? 1 : 0
}
