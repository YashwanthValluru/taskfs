resource "aws_security_group" "prometheus_sg" {
  name        = "${var.name_prefix}-prometheus-sg"
  description = "Allow Prometheus, Node Exporter, Thanos, SSH access"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Prometheus server port"
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = var.allowed_ips
  }

  ingress {
    description      = "Thanos sidecar grpc port"
    from_port        = 10901
    to_port          = 10901
    protocol         = "tcp"
    cidr_blocks      = var.allowed_ips
  }

  ingress {
    description      = "Thanos sidecar http port"
    from_port        = 10902
    to_port          = 10902
    protocol         = "tcp"
    cidr_blocks      = var.allowed_ips
  }

  ingress {
    description      = "Node Exporter port"
    from_port        = 9100
    to_port          = 9100
    protocol         = "tcp"
    cidr_blocks      = var.allowed_ips
  }

  ingress {
    description      = "SSH Port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.ssh_allowed_ips
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-prometheus-sg"
  }
}

output "security_group_id" {
  value = aws_security_group.prometheus_sg.id
}
