variable "bucket_name" {
  description = "Name of the S3 bucket for Thanos storage"
  type        = string
  default = "thanos-metrics-bucket-prod"

}
