terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
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
          "ec2:CreateSnapshot",
          "ec2:CreateVolume",
          "ec2:CreateTags",
          "ec2:DescribeSnapshots",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:DescribeTags",
          "elasticfilesystem:ListTagsForResource",
          "elasticfilesystem:ModifyMountTargetSecurityGroups",
          "events:*Rule*",
          "events:*Resource",
          "events:*EventBus",
          "events:*Targets",
          "events:*Permission",
          "workdocs:*Document*",
          "workdocs:*Labels",
          "workdocs:*Metadata",
          "workdocs:*NotificationSubscription"
        ]
        Resource = "*"
      },
      {
        Sid = "TagRestrictedSnapshotSharing${var.application_id}"
        Effect = "Allow"
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/CloudStorageSecExtraLargeFileScanning" = "ExtraLargeFileScanning"
          }
        }
        Action = [
          "ec2:ModifySnapshotAttribute",
          "ec2:DeleteSnapshot"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:ec2:*::snapshot/*"
        ]
      },
      {
        Sid = "AllResourcesInService${var.application_id}"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteObject*",
          "s3:GetBucket*",
          "s3:Get*Configuration",
          "s3:GetObject*",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketTagging",
          "s3:GetBucketVersioning",
          "s3:GetBucketLogging",
          "s3:GetLifecycleConfiguration",
          "s3:GetBucketWebsite",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:PutBucket*",
          "s3:PutObject*",
          "s3:Put*Configuration",
          "sns:ListSubscriptions",
          "sns:ListSubscriptionsByTopic",
          "sns:ListTopics",
          "sns:Subscribe",
          "sns:Unsubscribe"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:s3:::*",
          "arn:${data.aws_partition.current.partition}:sns:*:${data.aws_caller_identity.current.account_id}:*"
        ]
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
        Sid = "TagRestricted${var.application_id}"
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

resource "aws_iam_role_policy_attachment" "remote_access" {
  role       = local.create_cross_account_role ? aws_iam_role.remote_access[0].name : var.pre_existing_cross_account_role_name
  policy_arn = aws_iam_policy.remote_access.arn
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
          "events:TagResource"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:events:*:${var.primary_account_id}:event-bus/*${var.application_id}*",
          "arn:${data.aws_partition.current.partition}:events:*:${data.aws_caller_identity.current.account_id}:event-bus/*${var.application_id}*",
          "arn:${data.aws_partition.current.partition}:events:*:${data.aws_caller_identity.current.account_id}:rule/*${var.application_id}*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "event_bridge" {
  role       = local.create_event_bridge_role ? aws_iam_role.event_bridge_role[0].name : var.pre_existing_event_bridge_role_name
  policy_arn = aws_iam_policy.event_bridge.arn
}

