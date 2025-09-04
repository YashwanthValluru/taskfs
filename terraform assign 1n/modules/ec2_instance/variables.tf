variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0861f4e788f5069dd"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 instance will launch"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 instance role"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID attached to EC2 instance"
  type        = string
}

variable "is_public_subnet" {
  description = "Whether the subnet is public (assign public IP)"
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "prometheus_role" {
  description = "Role of this Prometheus instance: 'master' or 'slave'"
  type        = string
}

variable "master_ip" {
  description = "Private IP of the master Prometheus instance (for federation config)"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "AWS S3 bucket name for Thanos object storage"
  type        = string
}

variable "s3_bucket_region" {
  description = "Region of the S3 bucket"
  type        = string
}
