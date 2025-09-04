resource "aws_instance" "thanos_query" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile
  associate_public_ip_address = var.is_public_subnet
  security_groups        = [var.security_group_id]

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    store_grpc_addresses = join(",", var.store_grpc_addresses)
  })

  tags = {
    Name = "${var.name_prefix}-thanos-query"
  }
}

output "instance_public_ip" {
  value = aws_instance.thanos_query.public_ip
}

output "instance_private_ip" {
  value = aws_instance.thanos_query.private_ip
}
