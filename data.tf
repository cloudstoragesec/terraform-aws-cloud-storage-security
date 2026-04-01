data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "selected" {
  count = var.create_vpc_endpoints ? 1 : 0
  id    = var.vpc
}
