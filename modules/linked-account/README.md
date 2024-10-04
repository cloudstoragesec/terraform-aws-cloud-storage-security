# Cloud Storage Security Linked Account Terraform Module

## Overview

This Terraform submodule is designed to seamlessly link an additional AWS account to the main Cloud Storage Security (CSS) deployment. It establishes the necessary resources and configurations to enable secure access and monitoring across multiple AWS accounts.

## Prerequisites

Before using this submodule, ensure that you have successfully deployed the main Cloud Storage Security module as described in the [Cloud Storage Security Terraform Module](https://registry.terraform.io/modules/cloudstoragesec/cloud-storage-security/aws/latest). Additionally, you need the `external_id` from the console account page of the main deployment.

### Steps to Link an Account
* Navigate to the Linked Account page in the main Cloud Storage Security deployment.
* Click "Link Another Account," set the account ID, group, provide a nickname, and click "Link Account"
* Use the `external_id` provided in the console.
* Deploy this linked account Terraform module to create the required resources.
* Go back to the Linked Account page and click "Mark as Active" in the actions (...) menu.

### Example Usage
Example uses following named provider profiles:
```hcl
provider "aws" {
  alias   = "dev"
  region  = "us-east-1"
  profile = "dev"
}

provider "awscc" {
  region = "us-east-1"
}

provider "aws" {
  alias   = "testing"
  region  = "us-east-1"
  profile = "testing"
}
```
If The Main module is using the default values for the quarantine bucket, roles, and kms access:
```hcl
module "cloud-storage-security-linked-account" {
  providers            = {
     aws               = aws.testing
  }
  source               = "cloudstoragesec/cloud-storage-security/aws//modules/linked-account"
  external_id          = "cloudstoragesec-abcd123"
  application_id       = module.cloud-storage-security.application_id
  primary_account_id   = module.cloud-storage-security.primary_account_id
}
```
Alternatively almost all of the values needed for this module are provided as outputs from the cloud-storage-security module:
```hcl
module "cloud-storage-security-linked-account" {
providers                                    = {
   aws                                       = aws.testing
}
source                                       = "cloudstoragesec/cloud-storage-security/aws//modules/linked-account"
external_id                                  = "cloudstoragesec-abcd123" # provided by the CSS Console when linking an account
application_id                               = module.cloud-storage-security.application_id
primary_account_id                           = module.cloud-storage-security.primary_account_id
allow_access_to_all_kms_keys                 = module.cloud-storage-security.allow_access_to_all_kms_keys
quarantine_bucket_prefix                     = module.cloud-storage-security.quarantine_bucket_prefix
cross_account_role_name                      = module.cloud-storage-security.cross_account_role_name
cross_account_policy_name                    = module.cloud-storage-security.cross_account_policy_name
cross_account_ec2_policy_name                = module.cloud-storage-security.cross_account_ec2_policy_name
cross_account_event_bridge_role_name         = module.cloud-storage-security.cross_account_event_bridge_role_name
cross_account_event_bridge_policy_name       = module.cloud-storage-security.cross_account_event_bridge_policy_name
}
```