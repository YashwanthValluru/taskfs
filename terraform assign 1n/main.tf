provider "aws" {
  region  = var.aws_region
  profile = "Devops_SDE-738232692277"
}



module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  name_prefix        = var.name_prefix
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  bucket_name = var.s3_bucket_name
}

module "iam" {
  source = "./modules/iam"
  role_name    = "thanos-s3-access-role"
  s3_bucket_arn = module.s3_bucket.bucket_arn
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id          = module.vpc.vpc_id
  name_prefix     = var.name_prefix
  allowed_ips     = ["10.0.0.0/16"]  # adjust CIDR as needed
  ssh_allowed_ips = ["192.168.1.13/32"]  # restrict SSH to your IP
}

module "slave1" {
  source              = "./modules/ec2_instance"
  ami                 = var.ami
  instance_type       = var.instance_type
  subnet_id           = module.vpc.private_subnet_id
  iam_instance_profile= module.iam.iam_role_name
  security_group_id   = module.security_group.security_group_id
  is_public_subnet    = false
  name_prefix         = var.name_prefix
  prometheus_role     = "slave"
  master_ip           = ""  # No master IP needed here
  s3_bucket_name      = var.s3_bucket_name
  s3_bucket_region    = var.aws_region
}

module "slave2" {
  source              = "./modules/ec2_instance"
  ami                 = var.ami
  instance_type       = var.instance_type
  subnet_id           = module.vpc.private_subnet_id
  iam_instance_profile= module.iam.iam_role_name
  security_group_id   = module.security_group.security_group_id
  is_public_subnet    = false
  name_prefix         = var.name_prefix
  prometheus_role     = "slave"
  master_ip           = ""  # No master IP needed here
  s3_bucket_name      = var.s3_bucket_name
  s3_bucket_region    = var.aws_region
}

module "master" {
  source              = "./modules/ec2_instance"
  ami                 = var.ami
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet_id
  iam_instance_profile= module.iam.iam_role_name
  security_group_id   = module.security_group.security_group_id
  is_public_subnet    = true
  name_prefix         = var.name_prefix
  prometheus_role     = "master"
  master_ip           = module.slave1.instance_private_ip  # federation target IPs
  s3_bucket_name      = var.s3_bucket_name
  s3_bucket_region    = var.aws_region
}
