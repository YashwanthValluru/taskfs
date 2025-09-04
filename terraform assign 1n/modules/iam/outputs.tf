output "iam_role_name" {
  description = "The name of the IAM role created."
  value       = aws_iam_role.thanos_role.name
}

output "iam_role_arn" {
  description = "The ARN of the IAM role created."
  value       = aws_iam_role.thanos_role.arn
}
