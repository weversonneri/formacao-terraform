resource "aws_security_group" "acesso-ssh" { // cria um security group na aws
  name        = "acesso-ssh"
  description = "acesso-ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cdirs_acesso_remoto // ips alternativos
  }

  tags = {
    Name = "ssh"
  }
}
