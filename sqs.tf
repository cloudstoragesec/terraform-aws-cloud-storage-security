resource "aws_sqs_queue" "scanned_items_queue" {
  name                       = "${var.service_name}-ScannedItems-${local.application_id}"
  max_message_size           = 262144
  message_retention_seconds  = 1209600
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 1200

  kms_master_key_id = local.use_dynamo_cmk ? var.sqs_cmk_key_arn : "alias/aws/sqs"
}