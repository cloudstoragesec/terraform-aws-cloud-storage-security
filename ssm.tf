resource "aws_ssm_parameter" "dynamo_table_name_prefix" {
  name  = "/${local.ssm_path_prefix}/Config/DynamoTableNamePrefix"
  type  = "String"
  value = "${local.application_id}."
}

resource "aws_ssm_parameter" "dynamo_point_in_time_recovery_enabled" {
  name  = "/${local.ssm_path_prefix}/Config/DynamoPointInTimeRecoveryEnabled"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_ecr_image_url" {
  name  = "/${local.ssm_path_prefix}/Config/AgentEcrImageUrl"
  type  = "String"
  value = local.agent_image_url
}

resource "aws_ssm_parameter" "max_num_agents" {
  name  = "/${local.ssm_path_prefix}/Config/MaxNumAgents"
  type  = "String"
  value = var.max_running_agents
  lifecycle {
    ignore_changes = [value]
    precondition {
      condition     = var.max_running_agents >= var.min_running_agents
      error_message = "`max_running_agents` Cannot be less than `min_running_agents`"
    }
  }
}

resource "aws_ssm_parameter" "min_num_agents" {
  name  = "/${local.ssm_path_prefix}/Config/MinNumAgents"
  type  = "String"
  value = var.min_running_agents
  lifecycle {
    ignore_changes = [value]
    precondition {
      condition     = var.min_running_agents <= var.max_running_agents
      error_message = "`min_running_agents` Cannot be greater than `max_running_agents`"
    }
  }
}

resource "aws_ssm_parameter" "queue_scaling_threshold" {
  name  = "/${local.ssm_path_prefix}/Config/QueueScalingThreshold"
  type  = "String"
  value = "1000"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_cpu" {
  name  = "/${local.ssm_path_prefix}/Config/AgentCpu"
  type  = "String"
  value = "1024"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_memory" {
  name  = "/${local.ssm_path_prefix}/Config/AgentMemory"
  type  = "String"
  value = "3072"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_disk_size" {
  name  = "/${local.ssm_path_prefix}/Config/AgentDiskSize"
  type  = "String"
  value = "20"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "enable_large_file_scanning" {
  name  = "/${local.ssm_path_prefix}/Config/EnableLargeFileScanning"
  type  = "String"
  value = var.enable_large_file_scanning
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "storage_assessment_enabled" {
  name  = "/${local.ssm_path_prefix}/Config/StorageAssessmentEnabled"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "large_file_disk_size" {
  name  = "/${local.ssm_path_prefix}/Config/LargeFileDiskSize"
  type  = "String"
  value = var.large_file_disk_size_gb
  lifecycle {
    ignore_changes = [value]
    precondition {
      condition     = var.large_file_disk_size_gb >= 20 && var.large_file_disk_size_gb <= 16300
      error_message = "`large_file_disk_size` must be between 20 and 16,300 GB"
    }
  }
}

resource "aws_ssm_parameter" "large_file_ec2_tags" {
  name  = "/${local.ssm_path_prefix}/Config/LargeFileEC2Tags"
  type  = "String"
  value = "CloudStorageSec-[appId]=EC2Instance"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "subdomain" {
  name  = "/${local.ssm_path_prefix}/Config/Subdomain"
  type  = "String"
  value = "${local.account_id}-${local.application_id}"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "email" {
  name  = "/${local.ssm_path_prefix}/Config/Email"
  type  = "String"
  value = var.email
}

resource "aws_ssm_parameter" "user_name" {
  name  = "/${local.ssm_path_prefix}/Config/UserName"
  type  = "String"
  value = var.username
}

resource "aws_ssm_parameter" "stack_name" {
  name  = "/${local.ssm_path_prefix}/Config/StackName"
  type  = "String"
  value = var.service_name
}

resource "aws_ssm_parameter" "private_mirror" {
  name  = "/${local.ssm_path_prefix}/Config/PrivateMirror"
  type  = "String"
  value = "!!none_chosen!!"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "last_upgrade_notes_seen" {
  name  = "/${local.ssm_path_prefix}/Config/LastUpgradeNotesSeen"
  type  = "String"
  value = "v1.00.000"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "last_post_upgrade_procedure" {
  name  = "/${local.ssm_path_prefix}/Config/LastPostUpgradeProcedure"
  type  = "String"
  value = "v1.00.000"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "region" {
  name  = "/${local.ssm_path_prefix}/AWS/Region"
  type  = "String"
  value = local.aws_region
}

resource "aws_ssm_parameter" "user_pool_client_id" {
  name  = "/${local.ssm_path_prefix}/AWS/UserPoolClientId"
  type  = "String"
  value = aws_cognito_user_pool_client.main.id
}

resource "aws_ssm_parameter" "user_pool_client_secret" {
  name  = "/${local.ssm_path_prefix}/AWS/UserPoolClientSecret"
  type  = "String"
  value = aws_cognito_user_pool_client.main.client_secret
}
resource "aws_ssm_parameter" "user_pool_id" {
  name  = "/${local.ssm_path_prefix}/AWS/UserPoolId"
  type  = "String"
  value = aws_cognito_user_pool.main.id
}

resource "aws_ssm_parameter" "only_scan_when_queue_threshold_exceeded" {
  name  = "/${local.ssm_path_prefix}/Config/OnlyScanWhenQueueThresholdExceeded"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "quarantine_in_primary_account" {
  name  = "/${local.ssm_path_prefix}/Config/QuarantineInPrimaryAccount"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "security_hub_enabled" {
  name  = "/${local.ssm_path_prefix}/Config/SecurityHubEnabled"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "agent_scanning_engine" {
  name  = "/${local.ssm_path_prefix}/Config/AgentScanningEngine"
  type  = "String"
  value = var.agent_scanning_engine
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "multi_engine_scanning_mode" {
  name  = "/${local.ssm_path_prefix}/Config/MultiEngineScanningMode"
  type  = "String"
  value = var.multi_engine_scanning_mode
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ecr_account_id" {
  name  = "/${local.ssm_path_prefix}/Config/EcrAccountId"
  type  = "String"
  value = local.ecr_account
}

resource "aws_ssm_parameter" "quarantine_bucket_days_to_expire" {
  name  = "/${local.ssm_path_prefix}/Config/QuarantineBucketDaysToExpire"
  type  = "String"
  value = "0"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "auto_protect_bucket_tag_key" {
  name  = "/${local.ssm_path_prefix}/Config/AutoProtectBucketTagKey"
  type  = "String"
  value = "CloudStorageSecAutoProtect-${local.application_id}"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloud_trail_lake_enabled" {
  name  = "/${local.ssm_path_prefix}/Config/CloudTrailLakeEnabled"
  type  = "String"
  value = "false"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloud_trail_lake_event_data_store_name" {
  name  = "/${local.ssm_path_prefix}/Config/CloudTrailLakeEventDataStoreName"
  type  = "String"
  value = "CloudTrailLakeEventDataStoreName-${local.application_id}"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloud_trail_lake_channel_name" {
  name  = "/${local.ssm_path_prefix}/Config/CloudTrailLakeChannelName"
  type  = "String"
  value = "CloudStorageSecCloudTrailLake-${local.application_id}"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloud_trail_lake_channel_arn" {
  name  = "/${local.ssm_path_prefix}/Config/CloudTrailLakeArn"
  type  = "String"
  value = "unknown"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "guard_duty_s3_integration_enabled_regions" {
  name  = "/${local.ssm_path_prefix}/Config/GuardDutyS3IntegrationEnabledRegions"
  type  = "String"
  value = var.guard_duty_s3_integration_enabled_regions
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "guard_duty_s3_malware_result_types" {
  name  = "/${local.ssm_path_prefix}/Config/GuardDutyS3MalwareResultTypes"
  type  = "String"
  value = var.guard_duty_s3_malware_result_types
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "guard_duty_s3_malware_additional_scanning" {
  name  = "/${local.ssm_path_prefix}/Config/GuardDutyS3MalwareAdditionalScanning"
  type  = "String"
  value = var.guard_duty_s3_malware_additional_scanning
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "retro_scan_on_detected_infection" {
  name  = "/${local.ssm_path_prefix}/Config/RetroScanOnDetectedInfection"
  type  = "String"
  value = var.retro_scan_on_detected_infection
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "event_bridge_notifications_enabled" {
  name  = "/${local.ssm_path_prefix}/Config/EventBridgeNotificationsEnabled"
  type  = "String"
  value = var.eventbridge_notifications_enabled
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "event_bridge_notifications_bus_name" {
  name  = "/${local.ssm_path_prefix}/Config/EventBridgeNotificationsBusName"
  type  = "String"
  value = var.eventbridge_notifications_bus_name
  lifecycle {
    ignore_changes = [value]
  }
}
