resource "aws_cloudwatch_log_group" "main" {
  name = "${var.service_name}.ECS.${local.application_id}.Console"
  tags = merge({ (local.application_tag_key) = "ConsoleTargetGroup" },
    var.custom_resource_tags
  )
  retention_in_days = var.set_log_group_retention_policy ? var.log_retention_days : null
}

resource "aws_cloudwatch_metric_alarm" "health_check_console" {
  alarm_name          = "${var.service_name}HealthCheck-Alarm-${local.application_id}"
  alarm_description   = "Alarm triggered if there is no data in the last 5 minutes"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 3
  metric_name         = "ConsoleStatus"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Sum"
  treat_missing_data  = "breaching"
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name,
    ServiceName = local.ecs_service_name,
    Version     = local.image_version_console
  }

  alarm_actions = [
    aws_sns_topic.notifications.id
  ]
  insufficient_data_actions = [
    aws_sns_topic.notifications.id
  ]
  ok_actions = [
    aws_sns_topic.notifications.id
  ]
}

resource "aws_cloudwatch_event_bus" "proactive_notifications" {
  count = local.create_custom_event_bus ? 1 : 0
  name  = var.eventbridge_notifications_bus_name
  tags = merge({ (local.application_tag_key) = "ProactiveNotificationsEventBridgeBus" },
    var.custom_resource_tags
  )
}
