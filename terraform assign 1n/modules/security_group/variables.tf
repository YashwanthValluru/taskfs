variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for security group name"
  type        = string
}

variable "allowed_ips" {
  description = "List of CIDRs allowed to access Prometheus and Thanos services"
  type        = list(string)
  default     = ["10.0.0.0/16"] # Default private CIDR, override as necessary
}

variable "ssh_allowed_ips" {
  description = "List of CIDRs allowed SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change to restricted IPs in production
}
