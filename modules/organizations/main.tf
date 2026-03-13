terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# Validate that deploy_to_organization and organizational_unit_ids are not both set.
check "mutually_exclusive_deployment_targets" {
  assert {
    condition     = !(var.deploy_to_organization && length(var.organizational_unit_ids) > 0)
    error_message = "Set either deploy_to_organization = true OR organizational_unit_ids, not both."
  }
}

resource "aws_iam_role" "organizations_access" {
  name        = local.role_name
  description = "Allows the Cloud Storage Scan console to read AWS Organizations structure for automatic account discovery"

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

  tags = {
    Application   = "CloudStorageSecurity"
    ApplicationId = var.application_id
  }
}

resource "aws_iam_policy" "organizations_access" {
  name = local.policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "OrganizationsReadAccess"
        Effect = "Allow"
        Action = [
          "organizations:DescribeOrganization",
          "organizations:ListAccounts",
          "organizations:ListRoots",
          "organizations:ListOrganizationalUnitsForParent",
          "organizations:ListAccountsForParent",
          "organizations:DescribeOrganizationalUnit",
          "organizations:DescribeAccount",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "organizations_access" {
  role       = aws_iam_role.organizations_access.name
  policy_arn = aws_iam_policy.organizations_access.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# LINKED-ACCOUNT STACKSET
# Deploys cross-account IAM roles across all accounts in the organization or target OUs,
# mirroring what the Console does via CloudFormation StackSets.
# Created when deploy_to_organization = true OR organizational_unit_ids is provided.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudformation_stack_set" "linked_accounts" {
  count = local.deploy_stackset ? 1 : 0

  name             = local.stackset_name
  description      = "Deploys Cloud Storage Security cross-account scanning roles to linked accounts"
  permission_model = "SERVICE_MANAGED"

  template_url  = local.resolved_template_url
  template_body = var.linked_account_template_body

  auto_deployment {
    enabled                          = var.stackset_auto_deployment
    retain_stacks_on_account_removal = var.stackset_retain_on_removal
  }

  parameters = {
    ApplicationId                    = var.application_id
    ExternalId                       = coalesce(var.linked_account_external_id, var.external_id)
    PrimaryAccountId                 = var.primary_account_id
    AllowAccessToAllKmsKeys          = var.allow_access_to_all_kms_keys
    QuarantineBucketNamePrefix       = var.quarantine_bucket_prefix
    CrossAccountRoleName             = var.cross_account_role_name
    CrossAccountPolicyName           = var.cross_account_policy_name
    CrossAccountEventBridgeRoleName  = var.cross_account_event_bridge_role_name
    CrossAccountEventBridgePolicyName = var.cross_account_event_bridge_policy_name
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]

  lifecycle {
    ignore_changes = [administration_role_arn]
  }

  tags = {
    Application   = "CloudStorageSecurity"
    ApplicationId = var.application_id
  }
}

resource "aws_cloudformation_stack_set_instance" "linked_accounts" {
  count = local.deploy_stackset ? 1 : 0

  stack_set_name = aws_cloudformation_stack_set.linked_accounts[0].name

  deployment_targets {
    organizational_unit_ids = local.deployment_target_ids
  }

  operation_preferences {
    region_order         = local.resolved_stackset_regions
    max_concurrent_count = 10
  }
}
