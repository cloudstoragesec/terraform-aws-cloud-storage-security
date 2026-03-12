output "organizations_role_arn" {
  description = "The ARN of the IAM role for Organizations access. Provide this to Cloud Storage Security when linking your organization."
  value       = aws_iam_role.organizations_access.arn
}

output "organizations_role_name" {
  description = "The name of the IAM role for Organizations access."
  value       = aws_iam_role.organizations_access.name
}

output "external_id" {
  description = "The External ID used for this role (for reference)."
  value       = var.external_id
}
