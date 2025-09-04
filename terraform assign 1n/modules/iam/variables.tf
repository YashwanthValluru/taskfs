variable "role_name" {
  description = "Name of the IAM role."
  type        = string
  default     = "thanos-s3-access-role"
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket Thanos will access."
  type        = string
}
