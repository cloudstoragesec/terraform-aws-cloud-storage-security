terraform {
  required_providers {
    aws = {
      source      = "hashicorp/aws"
      version     = "6.37.0"
      constraints = ">= 4.0.0, ~> 6.37.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.72.1"
    }
  }
}
