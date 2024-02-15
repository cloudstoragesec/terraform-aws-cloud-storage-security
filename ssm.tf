resource "aws_ssm_parameter" "dynamo_table_name_prefix" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/DynamoTableNamePrefix"
  type  = "String"
  value = "${local.app_id}."
}

resource "aws_ssm_parameter" "dynamo_point_in_time_recovery_enabled" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/DynamoPointInTimeRecoveryEnabled"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_ecrImage_url" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/AgentEcrImageUrl"
  type  = "String"
  value = local.agent_image_url
}

resource "aws_ssm_parameter" "max_num_agents" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/MaxNumAgents"
  type  = "String"
  value = "12"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "min_num_agents" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/MinNumAgents"
  type  = "String"
  value = "1"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "queue_scaling_threshold" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/QueueScalingThreshold"
  type  = "String"
  value = "1000"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_cpu" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/AgentCpu"
  type  = "String"
  value = "1024"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_memory" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/AgentMemory"
  type  = "String"
  value = "3072"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_disk_size" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/AgentDiskSize"
  type  = "String"
  value = "20"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "enable_large_file_scanning" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/EnableLargeFileScanning"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "storage_assessment_enabled" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/StorageAssessmentEnabled"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "large_file_disk_size" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/LargeFileDiskSize"
  type  = "String"
  value = "2000"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "large_file_ec2_tags" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/LargeFileEC2Tags"
  type  = "String"
  value = "CloudStorageSec-[appId]=EC2Instance"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "subdomain" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/Subdomain"
  type  = "String"
  value = "${local.account_id}-${local.app_id}"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "email" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/Email"
  type  = "String"
  value = var.email
}

resource "aws_ssm_parameter" "user_name" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/UserName"
  type  = "String"
  value = var.username
}

resource "aws_ssm_parameter" "stack_name" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/StackName"
  type  = "String"
  value = var.service_name
}

resource "aws_ssm_parameter" "private_mirror" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/PrivateMirror"
  type  = "String"
  value = "!!none_chosen!!"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "last_upgrade_notes_seen" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/LastUpgradeNotesSeen"
  type  = "String"
  value = "v1.00.000"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "last_post_upgrade_procedure" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/LastPostUpgradeProcedure"
  type  = "String"
  value = "v1.00.000"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "region" {
  name  = "/${var.parameter_prefix}-${local.app_id}/AWS/Region"
  type  = "String"
  value = local.aws_region
}

resource "aws_ssm_parameter" "user_pool_client_id" {
  name  = "/${var.parameter_prefix}-${local.app_id}/AWS/UserPoolClientId"
  type  = "String"
  value = aws_cognito_user_pool_client.main.id
}

resource "aws_ssm_parameter" "user_pool_client_secret" {
  name  = "/${var.parameter_prefix}-${local.app_id}/AWS/UserPoolClientSecret"
  type  = "String"
  value = aws_cognito_user_pool_client.main.client_secret
}
resource "aws_ssm_parameter" "user_pool_id" {
  name  = "/${var.parameter_prefix}-${local.app_id}/AWS/UserPoolId"
  type  = "String"
  value = aws_cognito_user_pool.main.id
}

resource "aws_ssm_parameter" "only_scan_when_queue_threshold_exceeded" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/OnlyScanWhenQueueThresholdExceeded"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "quarantine_in_primary_account" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/QuarantineInPrimaryAccount"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "security_hub_enabled" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/SecurityHubEnabled"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_scanning_engine" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/AgentScanningEngine"
  type  = "String"
  value = var.agent_scanning_engine
}

resource "aws_ssm_parameter" "multi_engine_scanning_mode" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/MultiEngineScanningMode"
  type  = "String"
  value = var.multi_engine_scanning_mode
}

resource "aws_ssm_parameter" "ecr_account_id" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/EcrAccountId"
  type  = "String"
  value = local.ecr_account
}

resource "aws_ssm_parameter" "quarantine_bucket_days_to_expire" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/QuarantineBucketDaysToExpire"
  type  = "String"
  value = "0"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "auto_protect_bucket_tag_key" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/AutoProtectBucketTagKey"
  type  = "String"
  value = "CloudStorageSecAutoProtect-${local.app_id}"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloud_trail_lake_enabled" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/CloudTrailLakeEnabled"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloud_trail_lake_event_data_store_name" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/CloudTrailLakeEventDataStoreName"
  type  = "String"
  value = "CloudTrailLakeEventDataStoreName-${local.app_id}"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "CloudTrailLakeChannelNameParameter" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/CloudTrailLakeChannelName"
  type  = "String"
  value = "CloudStorageSecCloudTrailLake-${local.app_id}"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloud_trail_lake_channel_arn" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/CloudTrailLakeArn"
  type  = "String"
  value = "unknown"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "event_bridge_notifications_enabled" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/EventBridgeNotificationsEnabled"
  type  = "String"
  value = tostring(var.eventbridge_notifications_enabled)
  #lifecycle {
  #  ignore_changes = [value]
  #}
}

resource "aws_ssm_parameter" "event_bridge_notifications_bus_name" {
  name  = "/${var.parameter_prefix}-${local.app_id}/Config/EventBridgeNotificationsBusName"
  type  = "String"
  value = var.eventbridge_notifications_bus_name
  lifecycle {
    ignore_changes = [value]
  }
}
