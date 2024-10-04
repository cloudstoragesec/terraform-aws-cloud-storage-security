terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

resource "aws_iam_role" "remote_access" {
  count = local.create_cross_account_role ? 1 : 0
  name = local.cross_account_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${var.primary_account_id}:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "remote_access" {
  name = local.cross_account_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllResources${var.application_id}"
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "ec2:DescribeVolumes",
          "ec2:DescribeRegions",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVpc",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:DescribeTags",
          "elasticfilesystem:ListTagsForResource",
          "events:ListRuleNamesByTarget",
          "events:ListRules",
          "events:ListTargetsByRule",
          "events:ListEventBuses",
          "events:PutPermission",
          "events:RemovePermission"
        ]
        Resource = "*"
      },
      {
        Sid = "ElasticFileSystemActions${var.application_id}"
        Effect = "Allow"
        Action = [
          "elasticfilesystem:ModifyMountTargetSecurityGroups",
          "elasticfilesystem:DescribeMountTargetSecurityGroups",
          "elasticfilesystem:DescribeMountTargets"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:elasticfilesystem:*:${data.aws_caller_identity.current.account_id}:file-system/*",
          "arn:${data.aws_partition.current.partition}:elasticfilesystem:*:${data.aws_caller_identity.current.account_id}:access-point/*"
        ]
      },
      {
        Sid = "S3QuarentineActions${var.application_id}"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:PutLifecycleConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:PutBucketTagging",
          "s3:GetBucketTagging",
          "s3:GetObject",
          "s3:GetObjectTagging",
          "s3:GetObjectAttributes",
          "s3:PutObjectTagging",
          "s3:DeleteObject",
          "s3:DeleteObjectTagging",
          "s3:DeleteObjectVersion",
          "s3:DeleteObjectVersionTagging",
          "s3:DeleteBucketPolicy",
          "s3:PutBucketPolicy"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:s3:::${var.quarantine_bucket_prefix}*"
      },
      {
        Sid = "S3WriteActions${var.application_id}"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectTagging",
          "s3:PutBucketLogging",
          "s3:PutBucketNotification",
          "s3:PutBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutInventoryConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ]
        Resource = var.s3_allowed_bucket_prefixes == "*" ? [ "arn:${data.aws_partition.current.partition}:s3:::*" ] : split(",", var.s3_allowed_bucket_prefixes)
      },
      {
        Sid = "S3ReadOnly${var.application_id}"
        Effect = "Allow"
        Action = [
          "s3:GetBucketNotification",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketPolicyStatus",
          "s3:GetBucketEncryption",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:GetBucketTagging",
          "s3:GetBucketLogging",
          "s3:GetLifecycleConfiguration",
          "s3:GetBucketVersioning",
          "s3:GetInventoryConfiguration",
          "s3:GetBucketWebsite",
          "s3:GetObject*",
          "s3:GetEncryptionConfiguration",
          "s3:ListBucket",
          "s3:ListAllMyBuckets"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:s3:::*"
      },
      {
        Sid = "SnsAllActions${var.application_id}"
        Effect = "Allow"
        Action = [
          "sns:ListSubscriptions",
          "sns:ListTopics",
          "sns:Unsubscribe"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:sns:*:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Sid = "SnsApplicationActions${var.application_id}"
        Effect = "Allow"
        Action = [
          "sns:ListSubscriptionsByTopic",
          "sns:Subscribe",
          "sns:TagResource",
          "sns:UnTagResource"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:sns:*:${data.aws_caller_identity.current.account_id}:*${var.application_id}"
      },
      {
        Sid = "RestrictedResources${var.application_id}"
        Effect = "Allow"
        Action = [
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStacks",
          "cloudformation:UpdateStack",
          "iam:AttachRolePolicy",
          "iam:PassRole",
          "iam:PutRolePolicy",
          "s3:DeleteBucket"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:s3:::${var.quarantine_bucket_prefix}-${var.application_id}-*",
          "arn:${data.aws_partition.current.partition}:s3:::${var.quarantine_bucket_prefix}-${var.application_id}-*/*",
          "arn:${data.aws_partition.current.partition}:events:*:${data.aws_caller_identity.current.account_id}:*/*${var.application_id}",
          "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${local.cross_account_role_name}",
          "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${local.cross_account_event_bridge_role_name}"
        ]
      },
      {
        Sid = "KmsAccess${var.application_id}"
        Effect = "Allow"
        Condition = {
          StringLike = {
            "kms:ViaService" = "s3.*.${data.aws_partition.current.dns_suffix}"
          }
        }
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Resource = var.allow_access_to_all_kms_keys ? "*" : "arn:${data.aws_partition.current.partition}:kms:::key/no-blanket-kms-access"
      }      
    ]
  })
}

resource "aws_iam_policy" "remote_access_ec2_management" {
  name = local.cross_account_ec2_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "EC2CreateSnapshot${var.application_id}"
        Effect = "Allow"
        Condition = {
          StringEquals = {
            "ec2:RequestTag/CloudStorageSecApplication" = "${var.application_id}"
          }
        }
        Action = [
          "ec2:CreateTags",
          "ec2:CreateSnapshot"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:ec2:*::snapshot/*"
      },
      {
        Sid = "VpcPeering${var.application_id}"
        Effect = "Allow"
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/CloudStorageSecApplication" = "${var.application_id}"
          }
        }
        Action = [
          "ec2:AcceptVpcPeeringConnection"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:ec2:::vpc/*",
          "arn:${data.aws_partition.current.partition}:ec2:::vpc-peering-connection/*"
        ]
      },
      {
        Sid = "EC2CreateSnapshotForAnyVolume${var.application_id}"
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/*"
      },
      {
        Sid = "EC2DeleteSnapshot${var.application_id}"
        Effect = "Allow"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/CloudStorageSec-${var.application_id}": "Snapshot"
          }
        }
        Action = [
          "ec2:ModifySnapshotAttribute",
          "ec2:DeleteSnapshot"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:ec2:*::snapshot/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "remote_access" {
  role       = local.create_cross_account_role ? aws_iam_role.remote_access[0].name : var.pre_existing_cross_account_role_name
  policy_arn = aws_iam_policy.remote_access.arn
}

resource "aws_iam_role_policy_attachment" "remote_access_ec2_management" {
  role       = local.create_cross_account_role ? aws_iam_role.remote_access[0].name : var.pre_existing_cross_account_role_name
  policy_arn = aws_iam_policy.remote_access_ec2_management.arn
}

resource "aws_iam_role" "event_bridge_role" {
  count = local.create_event_bridge_role ? 1 : 0
  name = local.cross_account_event_bridge_role_name
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
  name = local.cross_account_event_bridge_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PutEvents${var.application_id}"
        Effect = "Allow"
        Action = [
          "events:PutEvents",
          "events:TagResource",
          "events:DeleteRule",
          "events:DescribeRule",
          "events:DisableRule",
          "events:EnableRule",
          "events:ListTargetsByRule",
          "events:PutRule",
          "events:ListTagsForResource",
          "events:TagResource",
          "events:UntagResource",
          "events:CreateEventBus",
          "events:DeleteEventBus",
          "events:DescribeEventBus",
          "events:UpdateEventBus",
          "events:PutTargets",
          "events:RemoveTargets"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:events:*:${var.primary_account_id}:event-bus/*${var.application_id}*",
          "arn:${data.aws_partition.current.partition}:events:*:${data.aws_caller_identity.current.account_id}:event-bus/*${var.application_id}*",
          "arn:${data.aws_partition.current.partition}:events:*:${data.aws_caller_identity.current.account_id}:rule/*${var.application_id}*",
          "arn:${data.aws_partition.current.partition}:events:*:${data.aws_caller_identity.current.account_id}:rule/*${var.application_id}*/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "event_bridge" {
  role       = local.create_event_bridge_role ? aws_iam_role.event_bridge_role[0].name : var.pre_existing_event_bridge_role_name
  policy_arn = aws_iam_policy.event_bridge.arn
}

resource "aws_iam_role_policy_attachment" "event_bridge_remote_role" {
  role       = local.create_cross_account_role ? aws_iam_role.remote_access[0].name : var.pre_existing_cross_account_role_name
  policy_arn = aws_iam_policy.event_bridge.arn
}


resource "aws_iam_policy" "workdocs" {
  count = var.create_workdocs_permissions ? 1 : 0
  name = "${var.service_name}WorkdocsPolicy-${var.application_id}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "WorkdocsActions${var.application_id}"
        Effect = "Allow"
        Action = [
          "workdocs:*Document*",
          "workdocs:*Labels",
          "workdocs:*Metadata",
          "workdocs:*NotificationSubscription"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "workdocs" {
  count      = var.create_workdocs_permissions ? 1 : 0
  role       = local.create_cross_account_role ? aws_iam_role.remote_access[0].name : var.pre_existing_cross_account_role_name
  policy_arn = aws_iam_policy.workdocs[0].arn
}
