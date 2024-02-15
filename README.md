# Cloud Storage Security Terraform Module

## Overview

This Terraform module facilitates the seamless setup and deployment of Cloud Storage Security (CSS) within an AWS environment as an alternative to the primary CloudFormation deployment method.

## Prerequisites
Subscribe to AWS Marketplace Listing
In order to run the product, you must be subscribed to one of Cloud Storage Security's listings in AWS Marketplace.

Our primary listing may be found at the link below. `Click Continue to Subscribe`, and continue until you reach the deployment step. This process will be run instead of the CloudFormation deployment that is described in the listing.

[Antivirus for Amazon S3 - PAYG with 30 DAY FREE TRIAL](https://aws.amazon.com/marketplace/pp/prodview-q7oc4shdnpc4w)

## Usage example

```hcl
module "cloud-storage-security" {
  source       = "cloudstoragesec/cloud-storage-security/aws"
  cidr         = "0.0.0.0/0"
  email        = "admin@example.com"
  subnet_a_id  = "subnet-aaa"
  subnet_b_id  = "subnet-bbb"
  vpc          = "vpc-xxx"
}
```

Follow these steps to deploy the module:

Module Initialization: Use Terraform to initialize the module.
Configure Variables: Set the necessary variables for your deployment.
Apply: Execute the Terraform plan and apply the deployment.

Upon completion, the module provides outputs such as ConsoleWebAddress and username. Refer to these outputs for accessing the deployed CSS Console.


For additional information and detailed help documentation, please visit the [Cloud Storage Security Help Docs](https://help.cloudstoragesec.com/) 