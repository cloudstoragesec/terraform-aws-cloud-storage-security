
resource "aws_iam_role" "appconfig_agent_configuration_document" {
  name = "AppConfigAgentConfigurationDocumentRole-${local.application_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "appconfig.amazonaws.com"
        }
      },
    ]
  })
  tags = merge({ (local.application_tag_key) = "AppConfigDocumentRole" },
    var.custom_resource_tags
  )
}

resource "aws_iam_role_policy" "appconfig_agent_configuration_document" {
  name = "AppConfigAgentConfigurationDocumentPolicy-${local.application_id}"
  role = aws_iam_role.appconfig_agent_configuration_document.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["ssm:GetDocument"],
        Resource = [
          "arn:${data.aws_partition.current.partition}:ssm:*:*:document/${awscc_ssm_document.appconfig_document.name}"
        ],
        Effect = "Allow"
      },
    ]
  })
}

resource "aws_iam_role" "user_pool_sns" {
  name = "${var.service_name}UserPoolRole-${local.application_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        }
      },
    ]
  })
  tags = merge({ (local.application_tag_key) = "UserPoolSnsRole" },
    var.custom_resource_tags
  )
}

resource "aws_iam_role_policy" "user_pool_sns" {
  name = "${var.service_name}UserPoolPolicy-${local.application_id}"
  role = aws_iam_role.user_pool_sns.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sns:publish"
        Effect   = "Allow"
        Sid      = ""
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "console_task" {
  name        = "${var.service_name}ConsoleRole-${local.application_id}"
  description = "Console ECS Task IAM Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        }
      },
    ]
  })
  managed_policy_arns = local.is_gov ? null : ["arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonECSInfrastructureRolePolicyForVolumes"]
  tags = merge({ (local.application_tag_key) = "ConsoleTaskRole" },
    var.custom_resource_tags
  )
}

resource "aws_iam_role_policy" "console_task" {
  name = "${var.service_name}ConsolePolicy-${local.application_id}"
  role = aws_iam_role.console_task.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DeleteLargeFileScanningVolumes${local.application_id}"
        Effect = "Allow"
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/CloudStorageSecExtraLargeFileScanning" = "ExtraLargeFileScanning"
          }
        }
        Action = [
          "ec2:DeleteVolume",
          "ec2:TerminateInstances"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:ec2:*:*:*"
      },
      {
        Action = [
          "acm:DescribeCertificate",
          "acm:RequestCertificate",
          "application-autoscaling:*ScalableTarget*",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:TagResource",
          "aws-marketplace:MeterUsage",
          "cloudformation:GetTemplateSummary",
          "cloudwatch:GetMetricStatistics",
          "ec2:AcceptVpcPeeringConnection",
          "ec2:CreateVpcPeeringConnection",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeInstances",
          "ec2:DescribeNetwork*",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeSnapshots",
          "ecs:CreateCluster",
          "ecs:*TaskDefinition*",
          "ecs:ListTasks",
          "ecs:RunTask",
          "fsx:DescribeFileSystems",
          "fsx:DescribeVolumes",
          "fsx:DescribeStorageVirtualMachines",
          "workdocs:*Document*",
          "workdocs:*Labels",
          "workdocs:*Metadata",
          "workdocs:*NotificationSubscription"
        ]
        Effect   = "Allow"
        Sid      = "AllResources${local.application_id}"
        Resource = "*"
      },
      {
        Action = [
          "ec2:*SecurityGroup*",
          "ec2:*Tags",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:ModifyNetworkInterfaceAttribute",
          "logs:CreateLogStream",
          "logs:DescribeLog*",
          "logs:FilterLogEvents",
          "logs:GetLog*",
          "logs:GetQueryResults",
          "logs:PutLogEvents",
          "logs:*Query",
          "logs:ListTagsForResource",
          "logs:TagResource",
          "s3:CreateBucket",
          "s3:GetBucket*",
          "s3:Get*Configuration",
          "s3:GetObject*",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:PutBucket*",
          "s3:PutObject*",
          "s3:Put*Configuration",
          "elasticfilesystem:CreateTags",
          "elasticfilesystem:CreateMountTarget",
          "elasticfilesystem:CreateAccessPoint",
          "elasticfilesystem:DeleteAccessPoint",
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:DescribeMountTargetSecurityGroups",
          "elasticfilesystem:DescribeTags",
          "elasticfilesystem:TagResource",
          "elasticfilesystem:UntagResource",
          "elasticfilesystem:ListTagsForResource",
          "elasticfilesystem:ModifyMountTargetSecurityGroups",
          "servicequotas:GetServiceQuota",
          "sns:ListSubscriptions*",
          "sns:ListTopics",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sqs:ListQueues"
        ]
        Effect = "Allow"
        Sid    = "AllResourcesInService${local.application_id}"
        Resource = [
          "arn:${data.aws_partition.current.partition}:cloudwatch:*:*:alarm:*",
          "arn:${data.aws_partition.current.partition}:ec2:*::image/*",
          "arn:${data.aws_partition.current.partition}:ec2:*::volume/*",
          "arn:${data.aws_partition.current.partition}:ec2:*::vpc-peering-connection/*",
          "arn:${data.aws_partition.current.partition}:ec2:*::vpc/*",
          "arn:${data.aws_partition.current.partition}:ec2:*:*:*",
          "arn:${data.aws_partition.current.partition}:logs:*:*:*",
          "arn:${data.aws_partition.current.partition}:s3:::*",
          "arn:${data.aws_partition.current.partition}:elasticfilesystem:*:*:file-system/*",
          "arn:${data.aws_partition.current.partition}:elasticfilesystem:*:*:access-point/*",
          "arn:${data.aws_partition.current.partition}:servicequotas:*:*:ebs/L-D18FCD1D",
          "arn:${data.aws_partition.current.partition}:servicequotas:*:*:ebs/L-7A658B76",
          "arn:${data.aws_partition.current.partition}:sns:*:*:*",
          "arn:${data.aws_partition.current.partition}:sqs:*:*:*"
        ]
      },
      {
        Action = [
          "appconfig:*Profile*",
          "appconfig:*Deployment",
          "appconfig:*agResource",
          "appconfig:UpdateDeploymentStrategy",
          "appconfig:UpdateApplication",
          "appconfig:UpdateEnvironment",
          "budgets:*",
          "cloudformation:DescribeStacks",
          "cloudformation:GetTemplateSummary",
          "cloudformation:UpdateStack",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:*agResource",
          "cognito-idp:*",
          "dynamodb:BatchWriteItem",
          "dynamodb:CreateTable",
          "dynamodb:DeleteItem",
          "dynamodb:DeleteTable",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:ListTagsOfResource",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:*agResource",
          "dynamodb:UpdateContinuousBackups",
          "dynamodb:UpdateItem",
          "dynamodb:UpdateTable",
          "ecr:ListImages",
          "ecs:CreateService",
          "ecs:DeleteCluster",
          "ecs:DeleteService",
          "ecs:Describe*",
          "ecs:ListContainerInstances",
          "ecs:ListTagsForResource",
          "ecs:StopTask",
          "ecs:*agResource",
          "ecs:UpdateService",
          "events:*Rule*",
          "events:*Resource",
          "events:*EventBus",
          "events:*Targets",
          "events:*Permission",
          "events:*Bus",
          "iam:*InstanceProfile",
          "iam:*RolePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:*agRole",
          "s3:PutEncryptionConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:DeleteBucket*",
          "s3:DeleteObject*",
          "securityhub:*Findings*",
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:RestoreSecret",
          "secretsmanager:TagResource",
          "sns:AddPermission",
          "sns:*Topic",
          "sns:*Attributes",
          "sns:ListSubscriptionsByTopic",
          "sns:Publish",
          "sns:*agResource",
          "sqs:*Queue*",
          "sqs:*Message",
          "sqs:*Attributes",
          "ssm:*Tags*",
          "ssm:*Document*",
          "ssm:*Parameter*"
        ]
        Effect = "Allow"
        Sid    = "RestrictedResources${local.application_id}"
        Resource = [
          "arn:${data.aws_partition.current.partition}:iam::${local.account_id}:role/${aws_iam_role.agent_task.name}",
          "arn:${data.aws_partition.current.partition}:iam::${local.account_id}:role/${aws_iam_role.appconfig_agent_configuration_document.name}",
          "arn:${data.aws_partition.current.partition}:iam::${local.account_id}:role/${aws_iam_role.console_task.name}",
          "arn:${data.aws_partition.current.partition}:iam::*:role/${aws_iam_role.ec2_container.name}",
          "arn:${data.aws_partition.current.partition}:iam::*:instance-profile/${aws_iam_role.ec2_container.name}",
          "arn:${data.aws_partition.current.partition}:iam::${local.account_id}:role/${aws_iam_role.execution.name}",
          "arn:${data.aws_partition.current.partition}:iam::${local.account_id}:role/${aws_iam_role.user_pool_sns.name}",
          "arn:${data.aws_partition.current.partition}:iam::*:role/${local.event_bridge_role_name}",
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:application/${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:application/${local.application_id}",
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:deploymentstrategy/${aws_appconfig_deployment_strategy.agent.id}",
          "arn:${data.aws_partition.current.partition}:cognito-idp:*:*:userpool/${aws_cognito_user_pool.main.id}",
          "arn:${data.aws_partition.current.partition}:cloudwatch:*:*:alarm:*${local.application_id}",
          "arn:${data.aws_partition.current.partition}:cloudwatch:*:*:alarm:TargetTracking-service/*${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:dynamodb:${local.aws_region}:*:table/${local.application_id}*",
          "arn:${data.aws_partition.current.partition}:ecs:*:*:service/*${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:ecs:*:*:cluster/*${local.application_id}",
          "arn:${data.aws_partition.current.partition}:ecs:*:*:task/*${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:ecs:*:*:task-definition/*${local.application_id}*",
          "arn:${data.aws_partition.current.partition}:events:*:*:*/*${local.application_id}*",
          "arn:${data.aws_partition.current.partition}:events:*:*:*/default",
          "arn:${data.aws_partition.current.partition}:events:*:*:event-bus/${var.eventbridge_notifications_bus_name}",
          "arn:${data.aws_partition.current.partition}:events:*:*:rule/*",
          "arn:${data.aws_partition.current.partition}:iam::*:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService",
          "arn:${data.aws_partition.current.partition}:s3:::*${local.application_id}*",
          "arn:${data.aws_partition.current.partition}:s3:::*${local.application_id}*/*",
          "arn:${data.aws_partition.current.partition}:sns:*:*:*${local.application_id}",
          "arn:${data.aws_partition.current.partition}:sqs:*:*:*${local.application_id}*",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/aws/service/ecs/optimized-ami/amazon-linux*/recommended/image_id",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:document/${awscc_ssm_document.appconfig_document.name}",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:document/${aws_ssm_document.appconfig_document_schema.name}",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/*${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/*${local.application_id}",
          "arn:${data.aws_partition.current.partition}:budgets::*:budget/*${local.application_id}",
          "arn:${data.aws_partition.current.partition}:budgets::*:budget/*${local.application_id}/action/*",
          "arn:${data.aws_partition.current.partition}:ecr:${local.aws_region}:${local.ecr_account}:repository/cloudstoragesecurity/*",
          "arn:${data.aws_partition.current.partition}:secretsmanager:${local.aws_region}:*:secret:cloudstoragesec/*",
          "arn:${data.aws_partition.current.partition}:securityhub:${local.aws_region}::product/cloud-storage-security/antivirus-for-amazon-s3",
          "arn:${data.aws_partition.current.partition}:securityhub:${local.aws_region}:*:product-subscription/cloud-storage-security/antivirus-for-amazon-s3",
          "arn:${data.aws_partition.current.partition}:securityhub:${local.aws_region}:*:hub/default"
        ]
      },
      {
        Effect = "Allow"
        Sid    = "Logs${local.application_id}"
        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy",
          "logs:*agLogGroup"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:logs:*:*:log-group:CloudStorageSecurity.*",
          "arn:${data.aws_partition.current.partition}:logs:*:*:log-group:CloudStorageSecurity.*:*"
        ]
      },
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Sid      = "CrossAccount${local.application_id}"
        Resource = "arn:${data.aws_partition.current.partition}:iam::*:role/*${local.application_id}"
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Sid      = "KmsConsole${local.application_id}"
        Resource = var.allow_access_to_all_kms_keys ? "*" : "arn:${data.aws_partition.current.partition}:kms:::key/no-blanket-kms-access"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "s3.*.amazonaws.com"
          }
        }
      },
      {
        Sid      = "PutMetricData${local.application_id}"
        Effect   = "Allow"
        Action   = "cloudwatch:PutMetricData"
        Resource = "*"
        Condition = {
          StringEquals = {
            "cloudwatch:Namespace" = "AWS/ECS"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "console_task_api_lb" {
  name = "${var.service_name}ConsolePolicy-${local.application_id}-ApiLb"
  role = aws_iam_role.console_task.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeAccountAttributes",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups"
        ]
        Effect   = "Allow"
        Sid      = "AllResources${local.application_id}"
        Resource = "*"
      },
      {
        Action = [
          "elasticloadbalancing:Create*",
          "elasticloadbalancing:Delete*",
          "elasticloadbalancing:Modify*",
          "elasticloadbalancing:*Tags",
          "elasticloadbalancing:SetSubnets",
          "iam:CreateServiceLinkedRole"
        ]
        Effect = "Allow"
        Sid    = "RestrictedResources${local.application_id}"
        Resource = [
          "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:listener/*/*${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:loadbalancer/*/*${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:targetgroup/*${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy" "console_task_aws_licensing" {
  name = "${var.service_name}ConsolePolicy-${local.application_id}-AwsLicensing"
  role = aws_iam_role.console_task.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "license-manager:CheckoutLicense",
          "license-manager:ListReceivedLicenses"
        ]
        Effect   = "Allow"
        Sid      = "AllResources${local.application_id}"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "cloud_trail_lake_policy" {
  name = "${var.service_name}ConsolePolicy-${local.application_id}-CloudTrailLake"
  role = aws_iam_role.console_task.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudtrail:*DataStore*",
          "cloudtrail:*Quer*",
          "cloudtrail:*Channel*",
          "cloudtrail-data:*Audit*",
          "iam:ListRoles",
          "iam:GetRolePolicy",
          "iam:GetUser"
        ]
        Effect   = "Allow"
        Sid      = "CloudTrail"
        Resource = "*"
      },
      {
        Action = [
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Sid      = "PassRole"
        Resource = "*"
        Condition = {
          StringEquals = { "iam:PassedToService" = "cloudtrail.amazonaws.com" }
        }

      },
    ]
  })
}

resource "aws_iam_policy" "custom_CMK" {
  count = (local.use_dynamo_cmk || local.use_sns_cmk) ? 1 : 0
  name  = "${var.service_name}KMSPolicy-${local.application_id}-CustomCMK"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:DescribeKey",
          "kms:GenerateDataKey*"
        ]
        Effect   = "Allow"
        Sid      = "CustomCMK"
        Resource = local.custom_key_list
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamo_cmk_console" {
  count      = (local.use_dynamo_cmk || local.use_sns_cmk) ? 1 : 0
  role       = aws_iam_role.console_task.name
  policy_arn = aws_iam_policy.custom_CMK[0].arn
}

resource "aws_iam_role_policy_attachment" "dynamo_cmk_agent" {
  count      = (local.use_dynamo_cmk || local.use_sns_cmk) ? 1 : 0
  role       = aws_iam_role.agent_task.name
  policy_arn = aws_iam_policy.custom_CMK[0].arn
}

resource "aws_iam_policy" "aws_bedrock" {
  count = var.aws_bedrock_enabled ? 1 : 0

  name = "${var.service_name}ConsolePolicy-${local.application_id}-AwsBedrock"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "bedrock:InvokeModel",
          "bedrock:GetFoundationModel",
          "bedrock:ListFoundationModels"
        ]
        Effect   = "Allow"
        Sid      = "Bedrock"
        Resource = "arn:aws:bedrock:*::foundation-model/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_bedrock_console" {
  count = var.aws_bedrock_enabled ? 1 : 0

  role       = aws_iam_role.console_task.name
  policy_arn = aws_iam_policy.aws_bedrock[0].arn
}

resource "aws_iam_role" "agent_task" {
  name = "${var.service_name}AgentRole-${local.application_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags = merge({ (local.application_tag_key) = "AgentTaskRole" },
    var.custom_resource_tags
  )
}

resource "aws_iam_role_policy" "agent_task" {
  name = "${var.service_name}AgentPolicy-${local.application_id}"
  role = aws_iam_role.agent_task.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "aws-marketplace:MeterUsage",
          "ec2:DescribeVpcs",
          "ec2:DescribeAvailabilityZones",
          "elasticfilesystem:DescribeMountTargets",
          "workdocs:*Document*",
          "workdocs:*Labels",
          "workdocs:*Metadata"
        ]
        Effect   = "Allow"
        Sid      = "AllResources${local.application_id}"
        Resource = "*"
      },
      {
        Action = [
          "appconfig:ListApplications",
          "appconfig:ListDeploymentStrategies",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:GetObject*",
          "s3:GetEncryptionConfiguration",
          "s3:ListBucket",
          "s3:PutObject*",
          "s3:PutEncryptionConfiguration",
          "ssm:ListDocuments"
        ]
        Effect = "Allow"
        Sid    = "AllResourcesInService${local.application_id}"
        Resource = [
          "arn:${data.aws_partition.current.partition}:s3:::*",
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:*",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:*"
        ]
      },
      {
        Action = [
          "appconfig:GetApplication",
          "appconfig:StartConfigurationSession",
          "appconfig:GetLatestConfiguration",
          "appconfig:GetConfiguration*",
          "appconfig:GetDeploymentStrategy",
          "appconfig:GetEnvironment",
          "appconfig:ListConfigurationProfiles",
          "appconfig:ListDeployments",
          "appconfig:ListEnvironments",
          "cognito-idp:*",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:PutLogEvents",
          "securityhub:BatchImportFindings",
          "sns:ConfirmSubscription",
          "sns:Publish",
          "sns:GetSubscriptionAttributes",
          "sns:ListSubscriptionsByTopic",
          "sqs:*Message",
          "sqs:GetQueueAttributes",
          "ssm:GetDocument",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Effect = "Allow"
        Sid    = "RestrictedResources${local.application_id}"
        #Add list
        Resource = [
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:application/${local.application_id}/configurationprofile/*",
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:application/${local.application_id}/environment/${aws_appconfig_environment.agent.environment_id}",
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:application/${local.application_id}/environment/${aws_appconfig_environment.agent.environment_id}/configuration/*",
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:application/${local.application_id}",
          "arn:${data.aws_partition.current.partition}:appconfig:*:*:deploymentstrategy/${aws_appconfig_deployment_strategy.agent.id}",
          "arn:${data.aws_partition.current.partition}:cognito-idp:*:*:userpool/${aws_cognito_user_pool.main.id}",
          "arn:${data.aws_partition.current.partition}:dynamodb:${local.aws_region}:*:table/${local.application_id}.*",
          "arn:${data.aws_partition.current.partition}:logs:*:*:*",
          "arn:${data.aws_partition.current.partition}:securityhub:${local.aws_region}::product/cloud-storage-security/antivirus-for-amazon-s3",
          "arn:${data.aws_partition.current.partition}:sns:*:*:awsworkdocs*",
          "arn:${data.aws_partition.current.partition}:sns:*:*:*${local.application_id}",
          "arn:${data.aws_partition.current.partition}:sqs:*:*:*${local.application_id}*",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:document/*${local.application_id}",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/*${local.application_id}/*",
          "arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/*${local.application_id}"
        ]
      },
      {
        Action   = "logs:CreateLogGroup"
        Effect   = "Allow"
        Sid      = "Logs${local.application_id}"
        Resource = "arn:${data.aws_partition.current.partition}:logs:*:*:*"
      },
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Sid      = "CrossAccount${local.application_id}"
        Resource = "arn:${data.aws_partition.current.partition}:iam::*:role/*${local.application_id}"
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Sid      = "Kms${local.application_id}"
        Resource = "*"
        Condition = {
          StringLike = { "kms:ViaService" = "s3.*.amazonaws.com" }
        }
      },
    ]
  })
}

#This is exec role
resource "aws_iam_role" "execution" {
  name = "${var.service_name}ExecutionRole-${local.application_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]

  tags = merge({ (local.application_tag_key) = "ExecutionRole" },
    var.custom_resource_tags
  )
}

resource "aws_iam_role" "ec2_container" {
  name = "${var.service_name}Ec2ContainerRole-${local.application_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"]

  tags = merge({ (local.application_tag_key) = "Ec2ContainerRole" },
    var.custom_resource_tags
  )
}

resource "aws_iam_role_policy" "ec2_container" {
  name = "${var.service_name}Ec2ContainerPolicy-${local.application_id}"
  role = aws_iam_role.ec2_container.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "TagRestrictedResources"
        Effect = "Allow"
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/CloudStorageSecExtraLargeFileScanning" = "ExtraLargeFileScanning"
          }
        }
        Action = [
          "ec2:DeleteSnapshot",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumeAttribute",
          "ec2:DetachVolume",
          "ec2:ModifySnapshotAttribute",
          "ec2:ModifyVolumeAttribute",
          "ec2:ModifyInstanceAttribute"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:ec2:*:${local.account_id}:*",
          "arn:${data.aws_partition.current.partition}:ec2:*:${local.account_id}:volume/*",
          "arn:${data.aws_partition.current.partition}:ec2:*::snapshot/*"
        ]
      },
      {
        Sid    = "TagResources"
        Effect = "Allow"
        Action = [
          "ec2:CreateTags"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:ec2:*:${local.account_id}:*",
          "arn:${data.aws_partition.current.partition}:ec2:*::image/*",
          "arn:${data.aws_partition.current.partition}:ec2:*::snapshot/*",
          "arn:${data.aws_partition.current.partition}:ec2:*:${local.account_id}:volume/*"
        ]
      },
      {
        Sid    = "AllResources"
        Effect = "Allow"
        Action = [
          "ec2:AttachVolume",
          "ec2:CopySnapshot",
          "ec2:CreateSnapshot",
          "ec2:CreateVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshotAttribute",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus"
        ]
        Resource = "*"
      },
      {
        Sid    = "KmsAccess"
        Effect = "Allow"
        Condition = {
          StringLike = {
            "kms:ViaService" = "ec2.*.${data.aws_partition.current.dns_suffix}"
          }
        }
        Action = [
          "kms:CreateGrant"
        ]
        Resource = var.allow_access_to_all_kms_keys ? "*" : "arn:${data.aws_partition.current.partition}:kms:::key/no-blanket-kms-access"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_container" {
  name = "${var.service_name}Ec2ContainerRole-${local.application_id}"
  role = aws_iam_role.ec2_container.name
}

resource "aws_iam_role" "event_bridge" {
  count = local.create_event_bridge_role ? 1 : 0
  name  = local.event_bridge_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "event_bridge" {
  name = "${var.service_name}EventBridgePolicy-${local.application_id}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PutEvents${local.application_id}"
        Effect = "Allow"
        Action = [
          "events:PutEvents"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:events:*:${local.account_id}:event-bus/*${local.application_id}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "event_bridge" {
  role       = local.create_event_bridge_role ? aws_iam_role.event_bridge[0].name : local.event_bridge_role_name
  policy_arn = aws_iam_policy.event_bridge.arn
}

resource "aws_iam_policy" "proactive_notifications_event_bridge" {
  count = local.create_custom_event_bus ? 1 : 0
  name  = "ProactiveNotificationsEventBridgePolicy-${local.application_id}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PutEvents${local.application_id}"
        Effect = "Allow"
        Action = [
          "events:PutEvents"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:events:*:${local.account_id}:event-bus/*${var.eventbridge_notifications_bus_name}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "custom_event_bridge_console" {
  count      = local.create_custom_event_bus ? 1 : 0
  role       = aws_iam_role.console_task.name
  policy_arn = aws_iam_policy.proactive_notifications_event_bridge[0].arn
}

resource "aws_iam_role_policy_attachment" "custom_event_bridge_agent" {
  count      = local.create_custom_event_bus ? 1 : 0
  role       = aws_iam_role.agent_task.name
  policy_arn = aws_iam_policy.proactive_notifications_event_bridge[0].arn
}
