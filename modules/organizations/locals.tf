locals {
  role_name   = "${var.organizations_role_prefix}${var.application_id}"
  policy_name = "${var.organizations_policy_prefix}${var.application_id}"

  # StackSet is deployed when targeting the whole org OR specific OUs.
  deploy_stackset = var.deploy_to_organization || length(var.organizational_unit_ids) > 0
  stackset_name   = "CloudStorageSec-LinkedAccounts-${var.application_id}"

  # Resolve deployment target IDs:
  # - deploy_to_organization = true → use the org root ID (r-xxxx) auto-discovered from the data source
  # - otherwise → use the explicitly provided OU IDs
  deployment_target_ids = var.deploy_to_organization ? [data.aws_organizations_organization.current[0].roots[0].id] : var.organizational_unit_ids

  # Default StackSet regions to the provider's region.
  resolved_stackset_regions = coalesce(var.stackset_regions, [data.aws_region.current.id])

  # Default to the official CSS LinkedAccount CFT hosted in S3.
  # Users can override with linked_account_template_url or linked_account_template_body.
  resolved_template_url = coalesce(var.linked_account_template_url, "https://css-cft.s3.amazonaws.com/LinkedAccountCloudFormationTemplate.yaml")
}
