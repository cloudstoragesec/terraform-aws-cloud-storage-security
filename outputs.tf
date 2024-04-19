output "console_web_address" {
  description = "Address of Console Web Interface"
  sensitive   = false
  value       = local.console_url
}

output "username" {
  description = "User Name used to log in to console"
  value       = var.username
}

output "proactive_notifications_topic_arn" {
  description = "ARN for the proactive notifications topic"
  value       = aws_sns_topic.notifications.arn
}

output "lb_arn" {
  description = "ARN for the console Load Balancer if LB is used"
  value = var.configure_load_balancer && var.existing_target_group_arn == null ? aws_lb.main[0].arn : null
}

# ---------------------------------------------------------------------------------------------------------------------
# These outputs are provided for convenience to be used in the linked account module.
# ---------------------------------------------------------------------------------------------------------------------

output "application_id" {
  description = "The Application ID that identifies the Antivirus for Amazon S3 deployment"
  value       = local.application_id
}

output "allow_access_to_all_kms_keys" {
  description = "Whether scanner has access to all KMS encrypted buckets"
  value       = var.allow_access_to_all_kms_keys
}

output "primary_account_id" {
  description = "The Account ID that is hosting the Antivirus for Amazon S3 deployment"
  value       = local.account_id
}

output "quarantine_bucket_prefix" {
  description = "Prefix for the quarantine bucket"
  value       = var.quarantine_bucket_prefix
}

output "cross_account_role_name" {
  description = "Cross-Account Scanning Role Name"
  value       = local.cross_account_role_name
}

output "cross_account_policy_name" {
  description = "Cross-Account Scanning Policy Name"
  value       = local.cross_account_policy_name
}

output "cross_account_event_bridge_role_name" {
  description = "Cross-Account Event Bridge Scanning Role Name"
  value       = local.event_bridge_role_name
}

output "cross_account_event_bridge_policy_name" {
  description = "Cross-Account Event Bridge Scanning Role Name"
  value       = aws_iam_policy.event_bridge.name
}