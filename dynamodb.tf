resource "aws_dynamodb_table" "buckets" {
  name         = "${local.application_id}.Buckets"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Name"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Name"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "dashboard_reports" {
  name         = "${local.application_id}.DashboardReports"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "efs_volumes" {
  name         = "${local.application_id}.EfsVolumes"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Id"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "ebs_volumes" {
  name         = "${local.application_id}.EbsVolumes"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Id"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "subnets" {
  name         = "${local.application_id}.Subnets"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Region"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Region"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "console" {
  name         = "${local.application_id}.Console"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ApplicationId"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "ApplicationId"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "linked_accounts" {
  name         = "${local.application_id}.LinkedAccounts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "AccountId"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "AccountId"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "work_docs_connections" {
  name         = "${local.application_id}.WorkDocsConnections"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "OrganizationId"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "OrganizationId"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "groups" {
  name         = "${local.application_id}.Groups"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Id"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "visible_groups" {
  name         = "${local.application_id}.VisibleGroups"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Username"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Username"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "scheduled_scans" {
  name         = "${local.application_id}.ScheduledScans"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ScheduleName"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "ScheduleName"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "scheduled_classifications" {
  name         = "${local.application_id}.ScheduledClassifications"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Name"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Name"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "deployment_status" {
  name         = "${local.application_id}.DeploymentStatus"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Region"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Region"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "proactive_monitor_statuses" {
  name         = "${local.application_id}.ProactiveMonitorStatuses"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Name"
  range_key    = "Region"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Name"
    type = "S"
  }

  attribute {
    name = "Region"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "storage_analysis" {
  name         = "${local.application_id}.StorageAnalysis"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "BucketName"
  range_key    = "ScanDate"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "BucketName"
    type = "S"
  }

  attribute {
    name = "ScanDate"
    type = "S"
  }

  attribute {
    name = "TrackerFlag"
    type = "N"
  }

  global_secondary_index {
    name            = "DateIndex"
    hash_key        = "TrackerFlag"
    range_key       = "ScanDate"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "file_count" {
  name         = "${local.application_id}.FileCount"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ScanDate"
  range_key    = "Guid"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "ScanDate"
    type = "S"
  }

  attribute {
    name = "Guid"
    type = "S"
  }

  attribute {
    name = "TrackerFlag"
    type = "N"
  }

  global_secondary_index {
    name            = "DateIndex"
    hash_key        = "TrackerFlag"
    range_key       = "ScanDate"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "agents" {
  name         = "${local.application_id}.Agents"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "AgentId"
  range_key    = "DeactivationDate"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "AgentId"
    type = "S"
  }

  attribute {
    name = "DeactivationDate"
    type = "S"
  }

  attribute {
    name = "Active"
    type = "N"
  }

  global_secondary_index {
    name            = "ActiveAndDeactivationDateIndex"
    hash_key        = "Active"
    range_key       = "DeactivationDate"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "agent_data" {
  name         = "${local.application_id}.AgentData"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "AgentId"
  range_key    = "Tstp"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "AgentId"
    type = "S"
  }

  attribute {
    name = "Tstp"
    type = "N"
  }

  attribute {
    name = "TrackerFlag"
    type = "N"
  }

  global_secondary_index {
    name            = "TstpIndex"
    hash_key        = "TrackerFlag"
    range_key       = "Tstp"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "bucket_scan_statistics" {
  name         = "${local.application_id}.BucketScanStatistics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "BucketName"
  range_key    = "Date"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "BucketName"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "S"
  }

  attribute {
    name = "TrackerFlag"
    type = "N"
  }

  global_secondary_index {
    name            = "DateIndex"
    hash_key        = "TrackerFlag"
    range_key       = "Date"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "bucket_classification_statistics" {
  name         = "${local.application_id}.BucketClassificationStatistics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "BucketName"
  range_key    = "Date"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "BucketName"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "S"
  }

  global_secondary_index {
    name            = "DateIndex"
    hash_key        = "Date"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "sophos_tap_data" {
  name         = "${local.application_id}.SophosTapData"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Date"
  range_key    = "Tstp"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Date"
    type = "S"
  }

  attribute {
    name = "Tstp"
    type = "N"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}
resource "aws_dynamodb_table" "daily_scan_statistics" {
  name         = "${local.application_id}.DailyScanStatistics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "AccountId"
  range_key    = "Date"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "AccountId"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "S"
  }
  attribute {
    name = "ScanType"
    type = "S"
  }

  attribute {
    name = "ScanEngine"
    type = "S"
  }
  attribute {
    name = "TrackerFlag"
    type = "N"
  }

  global_secondary_index {
    name            = "ScanTypeAndScanEngine"
    hash_key        = "ScanType"
    range_key       = "ScanEngine"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "LastRecordDate"
    hash_key        = "TrackerFlag"
    range_key       = "Date"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "monthly_scan_statistics" {
  name         = "${local.application_id}.MonthlyScanStatistics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "AccountId"
  range_key    = "Date"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "AccountId"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "S"
  }
  attribute {
    name = "TrackerFlag"
    type = "N"
  }

  attribute {
    name = "ScanType"
    type = "S"
  }
  attribute {
    name = "ScanEngine"
    type = "S"
  }

  global_secondary_index {
    name            = "ScanTypeAndScanEngine"
    hash_key        = "ScanType"
    range_key       = "ScanEngine"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "LastRecordDate"
    hash_key        = "TrackerFlag"
    range_key       = "Date"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "problem_files" {
  name         = "${local.application_id}.ProblemFiles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Guid"
  range_key    = "DateScanned"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Guid"
    type = "S"
  }

  attribute {
    name = "DateScanned"
    type = "S"
  }
  attribute {
    name = "AccountId"
    type = "S"
  }
  attribute {
    name = "AccountIdResult"
    type = "S"
  }

  global_secondary_index {
    name            = "AccountIdAndDateScanned"
    hash_key        = "AccountId"
    range_key       = "DateScanned"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "AccountIdResultAndDateScanned"
    hash_key        = "AccountIdResult"
    range_key       = "DateScanned"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "classification_results" {
  name         = "${local.application_id}.ClassificationResults"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Date"
  range_key    = "Guid"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Date"
    type = "S"
  }

  attribute {
    name = "Guid"
    type = "S"
  }
  attribute {
    name = "AccountId"
    type = "S"
  }

  global_secondary_index {
    name            = "AccountIdAndGuid"
    hash_key        = "AccountId"
    range_key       = "Guid"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "allowed_infected_files" {
  name         = "${local.application_id}.AllowedInfectedFiles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "BucketAndKey"
  range_key    = "VirusName"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "BucketAndKey"
    type = "S"
  }

  attribute {
    name = "VirusName"
    type = "S"
  }
  attribute {
    name = "DateAdded"
    type = "S"
  }
  attribute {
    name = "Active"
    type = "N"
  }

  global_secondary_index {
    name            = "ActiveAndDateAdded"
    hash_key        = "Active"
    range_key       = "DateAdded"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "group_membership" {
  name         = "${local.application_id}.GroupMembership"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ParentGroupId"
  range_key    = "ChildGroupId"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "ParentGroupId"
    type = "S"
  }

  attribute {
    name = "ChildGroupId"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "jobs" {
  name         = "${local.application_id}.Jobs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Type"
  range_key    = "Date"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Type"
    type = "S"
  }
  attribute {
    name = "Date"
    type = "S"
  }
  attribute {
    name = "EndDate"
    type = "S"
  }
  attribute {
    name = "Status"
    type = "N"
  }
  attribute {
    name = "ParentJobId"
    type = "S"
  }

  global_secondary_index {
    name            = "Status"
    hash_key        = "Status"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "TypeAndParentJobId"
    hash_key        = "Type"
    range_key       = "ParentJobId"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "TypeAndEndDate"
    hash_key        = "Type"
    range_key       = "EndDate"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "linked_account_membership" {
  name         = "${local.application_id}.LinkedAccountMembership"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "GroupId"
  range_key    = "AccountId"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "GroupId"
    type = "S"
  }

  attribute {
    name = "AccountId"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "license_file_history" {
  name         = "${local.application_id}.LicenseFileHistory"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Type"
  range_key    = "DateApplied"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Type"
    type = "S"
  }

  attribute {
    name = "DateApplied"
    type = "S"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "notifications" {
  name         = "${local.application_id}.Notifications"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Guid"
  range_key    = "Date"

  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }

  attribute {
    name = "Guid"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "S"
  }
  attribute {
    name = "AccountId"
    type = "S"
  }
  attribute {
    name = "Read"
    type = "N"
  }

  global_secondary_index {
    name            = "AccountIdAndDate"
    hash_key        = "AccountId"
    range_key       = "Date"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "ReadAndDate"
    hash_key        = "Read"
    range_key       = "Date"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }

  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "fsx_volumes" {
  name         = "${local.application_id}.FsxVolumes"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }
  attribute {
    name = "Id"
    type = "S"
  }
  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }
  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}


resource "aws_dynamodb_table" "job_networking" {
  name         = "${local.application_id}.JobNetworking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }
  attribute {
    name = "PK"
    type = "S"
  }
  attribute {
    name = "SK"
    type = "S"
  }
  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }
  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}

resource "aws_dynamodb_table" "classification_custom_rules" {
  name         = "${local.application_id}.ClassificationCustomRules"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"
  point_in_time_recovery {
    enabled = aws_ssm_parameter.dynamo_point_in_time_recovery_enabled.value
  }
  attribute {
    name = "Id"
    type = "S"
  }
  server_side_encryption {
    enabled     = local.use_dynamo_cmk
    kms_key_arn = var.dynamo_cmk_key_arn
  }
  tags = merge({ (local.application_tag_key) = "DynamoTable" },
    var.custom_resource_tags
  )
}