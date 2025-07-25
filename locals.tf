locals {
  # Terraform module and the associated app version are tightly coupled for compatibility. 
  # Specified 'image_version' corresponds to a tested combination of Terraform and app release.
  # Avoid manually changing the 'image_version' unless you have explicit instructions to do so.
  image_version_console   = "v9.01.003"
  image_version_agent     = "v9.01.003"
  ecr_account             = coalesce(var.ecr_account, local.is_gov ? "822167061992" : "564477214187")
  console_image_url       = "${local.ecr_account}.dkr.ecr.${local.aws_region}.amazonaws.com/cloudstoragesecurity/console:${local.image_version_console}"
  agent_image_url         = "${local.ecr_account}.dkr.ecr.${local.aws_region}.amazonaws.com/cloudstoragesecurity/agent:${local.image_version_agent}"
  application_id          = aws_appconfig_application.agent.id
  account_id              = coalesce(var.aws_account, data.aws_caller_identity.current.account_id)
  aws_region              = data.aws_region.current.name
  is_gov                  = data.aws_partition.current.partition == "aws-us-gov"
  console_url             = "${var.configure_load_balancer && var.existing_target_group_arn == null}" ? "https://${aws_lb.main[0].dns_name}" : "https://${local.account_id}-${local.application_id}.cloudstoragesecapp.com"
  use_proxy               = var.proxy_host != null
  create_custom_event_bus = var.eventbridge_notifications_enabled && var.eventbridge_notifications_bus_name != "default"
  use_dynamo_cmk          = var.dynamo_cmk_key_arn != null
  use_sns_cmk             = var.sns_cmk_key_arn != null
  use_sqs_cmk             = var.sqs_cmk_key_arn != null
  use_lb_subnets          = var.lb_subnet_a_id != null && var.lb_subnet_b_id != null
  ebs_volume_encryption_kms_key = var.ebs_volume_encryption && var.ebs_volume_encryption_kms_key_id != "default" ? var.ebs_volume_encryption_kms_key_id : null
  custom_key_list = concat(compact([
    var.dynamo_cmk_key_arn,
    var.sns_cmk_key_arn,
    var.sqs_cmk_key_arn,
    local.ebs_volume_encryption_kms_key
  ]), var.sns_cmk_keys_arn, var.sqs_cmk_keys_arn)
  application_tag_key           = (join("-", ["${var.service_name}", "${local.application_id}"]))
  create_event_bridge_role      = var.event_bridge_role_name == null
  event_bridge_role_name        = coalesce(var.event_bridge_role_name, "${var.service_name}EventBridgeRole-${local.application_id}")
  ecs_service_name              = "${var.service_name}ConsoleService-${local.application_id}"
  cross_account_role_name       = "${var.service_name}RemoteRole-${local.application_id}"
  cross_account_policy_name     = "${var.service_name}RemotePolicy-${local.application_id}"
  cross_account_ec2_policy_name = "${var.service_name}EC2RemotePolicy-${local.application_id}"
  ssm_path_prefix               = "${var.parameter_prefix}-${local.application_id}"
  application_bucket_name       = "${var.application_bucket_prefix}-${local.application_id}"
  product_name = lookup(
    {
      "AV"    = "Antivirus"
      "DC"    = "Data Classification"
      "S3"    = "Malware protection for Amazon S3"
      "MFT"   = "Antivirus for Managed File Transfers"
      "DLP"   = "Data Loss Prevention (DLP) for Amazon S3 & EC2"
      "EFS"   = "Malware protection for EFS"
      "GenAi" = "GenAI Secure Malware protection & Data Loss Prevention (DLP)"
    },
    var.product_listing,
    "Antivirus"
  )
  product_mode = lookup(
    {
      "S3"    = "Both"
      "MFT"   = "Both"
      "DLP"   = "Both"
      "EFS"   = "Both"
      "GenAi" = "Both"
    },
    var.product_listing,
    var.product_mode
  )
}
