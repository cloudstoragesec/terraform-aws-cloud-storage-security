# Cloud Storage Security Terraform Module

## Overview

This Terraform module facilitates the seamless setup and deployment of Cloud Storage Security (CSS) within an AWS environment as an alternative to the primary CloudFormation deployment method.

## Prerequisites
Subscribe to AWS Marketplace Listing
In order to run the product, you must be subscribed to one of Cloud Storage Security's listings in AWS Marketplace.

Our primary listing may be found at the link below. `Click Continue to Subscribe`, and continue until you reach the deployment step. This process will be run instead of the CloudFormation deployment that is described in the listing.

[Antivirus for Amazon S3 - PAYG with 30 DAY FREE TRIAL](https://aws.amazon.com/marketplace/pp/prodview-q7oc4shdnpc4w)

## Usage example

Example of a minimal deploy using only required inputs: 
```hcl
module "cloud-storage-security" {
  source       = "cloudstoragesec/cloud-storage-security/aws"
  cidr         = "0.0.0.0/0" #The CIDR block which is allowed access to the CSS Console (e.g. 0.0.0.0/0 for open access)
  email        = "admin@example.com" #The email address to be used for the initial admin account created for the CSS Console
  subnet_a_id  = "subnet-aaa" #A subnet ID within the VPC that may be used for ECS tasks for this deployment
  subnet_b_id  = "subnet-bbb" #A second subnet ID within the VPC that may be used for ECS tasks for this deployment. We recommend choosing subnets in different availability zones
  vpc          = "vpc-xxx" #The VPC ID in which to place the public facing Console
}
```
Refer to the inputs/outputs tabs for additional customization options and their descriptions.

Follow these steps to deploy the module:

Module Initialization: Use Terraform to initialize the module.
Configure Variables: Set the necessary variables for your deployment.
Apply: Execute the Terraform plan and apply the deployment.

Upon completion, the module provides outputs such as console_web_address and username. Refer to these outputs for accessing the deployed CSS Console.
```hcl
output "console_web_address" {
  value = module.cloud-storage-security.console_web_address
}
output "username" {
  value = module.cloud-storage-security.username
}
```

For additional information and detailed help documentation, please visit the [Cloud Storage Security Help Docs](https://help.cloudstoragesec.com/) 