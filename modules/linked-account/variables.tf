variable application_id {
  description = "The Application ID that identifies the Antivirus for Amazon S3 deployment"
  type = string
}

variable external_id {
  description = "The unique External ID that was provided upon adding this linked account"
  type = string
}

variable primary_account_id {
  description = "The Account ID that is hosting the Antivirus for Amazon S3 deployment"
  type = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "service_name" {
  description = <<EOF
    A prefix to place on resources that this Terraform template creates. 
    May be overriden if there is an organizational standard for resource name prefixes that needs to be followed. 
    values: any string, but should be short to avoid possibly attempting to create resources with names that exceed the max allowed length
    If optional roles names are not specified will be used to generate defaults using the same pattern as the parent module.   
  EOF
  type        = string
  default     = "CloudStorageSec"
}

variable "allow_access_to_all_kms_keys" {
  description = "Pick true if you would like to give the scanner access to all KMS encrypted buckets"
  type        = bool
  default     = true
}

variable "quarantine_bucket_prefix" {
  description = "Prefix for the quarantine bucket"
  type        = string
  default     = "cloudstoragesecquarantine"
}

variable cross_account_role_name {
  description = "Cross-Account Scanning Role Name"
  type = string
  default = null
}

variable cross_account_policy_name {
  description = "Cross-Account Scanning Policy Name"
  type = string
  default = null
}

variable cross_account_event_bridge_role_name {
  description = "Cross-Account Event Bridge Scanning Role Name"
  type = string
  default = null
}

variable cross_account_event_bridge_policy_name {
  description = "Cross-Account Scanning Policy Name"
  type = string
  default = null
}

variable pre_existing_cross_account_role_name {
  description = <<EOF
    OPTIONAL Custom Pre-Existing Role Name. If specified, this deployment will not create a new role. 
    This specified role must exist prior to deploying this stack, and you must configure the trust relationship as seen in this template. 
    This role name must match the name expected by the Console
  EOF
  type = string
  default = null
}

variable pre_existing_event_bridge_role_name {
  description = <<EOF
    OPTIONAL Custom Pre-Existing Role Name. If specified, this deployment will not create a new role.
    This specified role must exist prior to deploying this stack, and you must configure the trust relationship as seen in this template.
    This role name must match the name expected by the Console
  EOF
  type = string
  default = null
}

