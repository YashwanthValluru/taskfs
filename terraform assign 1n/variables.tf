variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "name_prefix" {
  type    = string
  default = "prod"
}

variable "s3_bucket_name" {
  type    = string
  default = "thanos-metrics-bucket-prod"
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 (Example, update as per region)
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}
