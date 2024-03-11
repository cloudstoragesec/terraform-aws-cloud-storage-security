resource "aws_sns_topic" "notifications" {
  name = "${var.service_name}NotificationsTopic-${local.application_id}"

  kms_master_key_id = var.sns_cmk_key_arn

  tags = merge({ (local.application_tag_key) = "ConsoleSnsTopic" },
    var.custom_resource_tags
  )
}

resource "aws_sns_topic_policy" "notifications_topic" {
  arn    = aws_sns_topic.notifications.arn
  policy = data.aws_iam_policy_document.notifications_topic.json
}

data "aws_iam_policy_document" "notifications_topic" {
  policy_id = "2012-10-17"

  statement {
    actions = ["sns:Publish"]
    effect  = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_role.agent_task.arn}",
        "${aws_iam_role.console_task.arn}"
      ]
    }

    resources = [
      aws_sns_topic.notifications.arn
    ]

    sid = "2012-10-17"
  }
}

/* https://github.com/hashicorp/terraform-provider-aws/issues/32072
resource "aws_sns_topic_subscription" "health_check_console_alarm" {
  protocol  = "email-json"
  endpoint  = var.email
  topic_arn = aws_sns_topic.NotificationsTopic.id
  filter_policy = jsonencode({
    "AlarmName" : [aws_cloudwatch_metric_alarm.health_check_console_alarm.arn]
  })
  filter_policy_scope = "MessageBody"
}
*/