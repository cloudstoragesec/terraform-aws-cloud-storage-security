terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
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
