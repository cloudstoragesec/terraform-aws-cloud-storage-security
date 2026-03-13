# Cloud Storage Security Organizations Terraform Module

## Overview

This Terraform submodule links an AWS Organization to the main Cloud Storage Security (CSS) deployment. It creates an IAM role in your AWS Organizations management account that allows CSS to discover accounts across your organization automatically. Optionally, it deploys a CloudFormation StackSet to roll out linked-account scanning roles to all accounts in the organization or to specific Organizational Units (OUs).

## Prerequisites

Before using this submodule, ensure that you have successfully deployed the main Cloud Storage Security module as described in the [Cloud Storage Security Terraform Module](https://registry.terraform.io/modules/cloudstoragesec/cloud-storage-security/aws/latest). Additionally, you need the `external_id` from the console organization linking page of the main deployment.

### Steps to Link an Organization
* Navigate to the Manage Accounts page in the main Cloud Storage Security deployment.
* Click "Link Organization," enter the Management Account ID, select a default group, and click "Link Organization."
* Use the `external_id` provided in the console.
* Deploy this organizations Terraform module in your **management account** to create the required IAM role.
* Optionally, set `deploy_to_organization = true` to automatically deploy linked-account scanning roles across all accounts via a CloudFormation StackSet.
* Go back to the Manage Accounts page and verify the organization appears in the Organizations table.

## Deployment Modes

### Organizations Role Only (default)
Creates only the IAM role for organization discovery. Linked accounts must be deployed individually using the [linked-account submodule](https://registry.terraform.io/modules/cloudstoragesec/cloud-storage-security/aws/latest/submodules/linked-account).

### Organization-wide StackSet (`deploy_to_organization = true`)
Creates the IAM role **and** a CloudFormation StackSet that deploys linked-account scanning roles to **all accounts** in the organization. The module auto-discovers the organization root ID. New accounts added to the organization are automatically included when `stackset_auto_deployment` is enabled (default).

### OU-targeted StackSet (`organizational_unit_ids`)
Creates the IAM role **and** a CloudFormation StackSet that deploys linked-account scanning roles only to accounts in the **specified OUs**. Use this when you want to limit scanning to specific parts of your organization.

> **Note:** `deploy_to_organization` and `organizational_unit_ids` are mutually exclusive. Set one or the other, not both.

## Example Usage

### Minimal: Organizations Role Only
```hcl
provider "aws" {
  alias   = "management"
  region  = "us-east-1"
  profile = "management-org"
}

module "cloud-storage-security-organizations" {
  providers = {
    aws = aws.management
  }
  source             = "cloudstoragesec/cloud-storage-security/aws//modules/organizations"
  external_id        = "cloudstoragesec-abcd123"  # provided by the CSS Console when linking an organization
  application_id     = module.cloud-storage-security.application_id
  primary_account_id = module.cloud-storage-security.primary_account_id
}
```

### Deploy to Entire Organization
```hcl
module "cloud-storage-security-organizations" {
  providers = {
    aws = aws.management
  }
  source                 = "cloudstoragesec/cloud-storage-security/aws//modules/organizations"
  external_id            = "cloudstoragesec-abcd123"
  application_id         = module.cloud-storage-security.application_id
  primary_account_id     = module.cloud-storage-security.primary_account_id
  deploy_to_organization = true
}
```

### Deploy to Specific OUs
```hcl
module "cloud-storage-security-organizations" {
  providers = {
    aws = aws.management
  }
  source                  = "cloudstoragesec/cloud-storage-security/aws//modules/organizations"
  external_id             = "cloudstoragesec-abcd123"
  application_id          = module.cloud-storage-security.application_id
  primary_account_id      = module.cloud-storage-security.primary_account_id
  organizational_unit_ids = ["ou-xxxx-xxxxxxxx", "ou-yyyy-yyyyyyyy"]
}
```

### Full Example with All StackSet Parameters
```hcl
module "cloud-storage-security-organizations" {
  providers = {
    aws = aws.management
  }
  source                                = "cloudstoragesec/cloud-storage-security/aws//modules/organizations"
  external_id                           = "cloudstoragesec-abcd123"
  application_id                        = module.cloud-storage-security.application_id
  primary_account_id                    = module.cloud-storage-security.primary_account_id
  deploy_to_organization                = true
  allow_access_to_all_kms_keys          = module.cloud-storage-security.allow_access_to_all_kms_keys
  quarantine_bucket_prefix              = module.cloud-storage-security.quarantine_bucket_prefix
  cross_account_role_name               = module.cloud-storage-security.cross_account_role_name
  cross_account_policy_name             = module.cloud-storage-security.cross_account_policy_name
  cross_account_event_bridge_role_name  = module.cloud-storage-security.cross_account_event_bridge_role_name
  cross_account_event_bridge_policy_name = module.cloud-storage-security.cross_account_event_bridge_policy_name
}
```
