output "iam_role_arn" {
  description = "IAM Role ARN created for letting the Pod authenticate through IRSA"
  value       = module.this.iam_role_arn
}

output "iam_role_name" {
  description = "IAM Role ARN created for letting the Pod authenticate through IRSA"
  value       = module.this.iam_role_name
}
