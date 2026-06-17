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
  value       = var.configure_load_balancer && var.existing_target_group_arn == null ? aws_lb.main[0].arn : null
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

output "cross_account_ec2_policy_name" {
  description = "Cross-Account EC2 Scanning Policy Name"
  value       = local.cross_account_ec2_policy_name
}

output "cross_account_event_bridge_role_name" {
  description = "Cross-Account Event Bridge Scanning Role Name"
  value       = local.event_bridge_role_name
}

output "cross_account_event_bridge_policy_name" {
  description = "Cross-Account Event Bridge Scanning Policy Name"
  value       = aws_iam_policy.event_bridge.name
}

output "console_security_group_id" {
  description = "ID of the Console security group (used when load balancer is not configured)"
  value       = var.configure_load_balancer ? null : aws_security_group.console[0].id
}

output "console_with_load_balancer_security_group_id" {
  description = "ID of the Console security group (used when load balancer is configured)"
  value       = var.configure_load_balancer ? aws_security_group.console_with_load_balancer[0].id : null
}

output "load_balancer_security_group_id" {
  description = "ID of the Load Balancer security group (used when load balancer is configured)"
  value       = var.configure_load_balancer ? aws_security_group.load_balancer[0].id : null
}

# ---------------------------------------------------------------------------------------------------------------------
# SSO Outputs (only populated when sso_provider_name and sso_metadata_url are set)
# ---------------------------------------------------------------------------------------------------------------------

output "sso_saml_entity_id" {
  description = "SAML Entity ID (Audience / Identifier) to register in your Identity Provider. Null when SSO is not enabled."
  value       = local.enable_sso ? "urn:amazon:cognito:sp:${aws_cognito_user_pool.main.id}" : null
}

output "sso_saml_reply_url" {
  description = "SAML Reply URL (Assertion Consumer Service URL) to register in your Identity Provider. Null when SSO is not enabled."
  value       = local.enable_sso ? "https://${local.sso_domain_prefix}.auth.${local.aws_region}.amazoncognito.com/saml2/idpresponse" : null
}

output "sso_hosted_ui_sign_in_url" {
  description = "Cognito Hosted UI sign-in URL for testing SSO directly. Null when SSO is not enabled."
  value       = local.enable_sso ? "https://${local.sso_domain_prefix}.auth.${local.aws_region}.amazoncognito.com/login?response_type=code&client_id=${aws_cognito_user_pool_client.main.id}&identity_provider=${var.sso_provider_name}" : null
}