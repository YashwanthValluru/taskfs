resource "aws_instance" "prometheus" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile
  associate_public_ip_address = var.is_public_subnet
  security_groups        = [var.security_group_id]

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    prometheus_role     = var.prometheus_role
    master_ip           = var.master_ip
    s3_bucket_name      = var.s3_bucket_name
    s3_bucket_region    = var.s3_bucket_region
  })

  tags = {
    Name = "${var.name_prefix}-${var.prometheus_role}"
  }
}

output "instance_public_ip" {
  value = aws_instance.prometheus.public_ip
}

output "instance_private_ip" {
  value = aws_instance.prometheus.private_ip
}
