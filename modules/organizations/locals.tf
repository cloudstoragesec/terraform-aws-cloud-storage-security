locals {
  role_name   = "${var.organizations_role_prefix}${var.application_id}"
  policy_name = "${var.organizations_policy_prefix}${var.application_id}"
}
