terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 7.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.72.1"
    }
  }
}
