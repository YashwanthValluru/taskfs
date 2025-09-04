output "slave1_instance_ip" {
  value = module.slave1.instance_private_ip
}

output "slave2_instance_ip" {
  value = module.slave2.instance_private_ip
}

output "master_instance_ip" {
  value = module.master.instance_public_ip
}

output "s3_bucket_name" {
  value = var.s3_bucket_name
}
