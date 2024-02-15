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
