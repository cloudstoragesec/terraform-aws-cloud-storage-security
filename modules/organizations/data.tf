data "aws_partition" "current" {}
data "aws_region" "current" {}

# Look up the organization roots when deploying to the entire organization.
# This provides the root ID (r-xxxx) needed for StackSet deployment targets.
data "aws_organizations_organization" "current" {
  count = var.deploy_to_organization ? 1 : 0
}
