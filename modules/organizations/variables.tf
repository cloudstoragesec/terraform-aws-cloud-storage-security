variable "application_id" {
  description = "The Application ID that identifies the Cloud Storage Security deployment"
  type        = string
}

variable "external_id" {
  description = "The unique External ID provided by the Cloud Storage Scan console when linking an organization"
  type        = string
}

variable "primary_account_id" {
  description = "The Account ID that is hosting the Cloud Storage Scan deployment"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults matching the CFT.
# ---------------------------------------------------------------------------------------------------------------------

variable "organizations_role_prefix" {
  description = "Prefix for the name of the IAM role for Organizations access."
  type        = string
  default     = "CloudStorageSecOrganizationsRole-"
}

variable "organizations_policy_prefix" {
  description = "Prefix for the name of the IAM policy for Organizations access."
  type        = string
  default     = "CloudStorageSecOrganizationsPolicy-"
}

# ---------------------------------------------------------------------------------------------------------------------
# STACKSET PARAMETERS
# A CloudFormation StackSet is created when deploy_to_organization = true OR organizational_unit_ids is provided.
# - deploy_to_organization = true: deploys to the entire organization (auto-discovers the root ID).
# - organizational_unit_ids: deploys only to the specified OUs.
# ---------------------------------------------------------------------------------------------------------------------

variable "deploy_to_organization" {
  description = "Deploy the linked-account StackSet to the entire organization. When true, the module auto-discovers the organization root ID. Mutually exclusive with organizational_unit_ids."
  type        = bool
  default     = false
}

variable "organizational_unit_ids" {
  description = "List of AWS Organizations OU IDs to deploy the linked-account StackSet into. Leave empty to skip StackSet deployment. Mutually exclusive with deploy_to_organization."
  type        = list(string)
  default     = []
}

variable "linked_account_template_url" {
  description = "S3 URL of the LinkedAccount CloudFormation template. Defaults to the official CSS-hosted template at css-cft.s3.amazonaws.com."
  type        = string
  default     = null
}

variable "linked_account_template_body" {
  description = "Inline CloudFormation template body for the linked-account stack. When set, takes precedence over linked_account_template_url."
  type        = string
  default     = null
}

variable "stackset_regions" {
  description = "AWS regions where the StackSet instances will be deployed. Defaults to the provider's region."
  type        = list(string)
  default     = null
}

variable "linked_account_external_id" {
  description = "The External ID for linked account cross-account role assumption. Required when deploying StackSet."
  type        = string
  default     = null
}

variable "allow_access_to_all_kms_keys" {
  description = "Give the scanner access to all KMS encrypted buckets in linked accounts."
  type        = string
  default     = "Yes"
}

variable "quarantine_bucket_prefix" {
  description = "Quarantine bucket name prefix for linked accounts."
  type        = string
  default     = "cloudstoragesecquarantine"
}

variable "cross_account_role_name" {
  description = "Override for the cross-account scanning role name. Use 'default' for standard naming."
  type        = string
  default     = "default"
}

variable "cross_account_policy_name" {
  description = "Override for the cross-account scanning policy name. Use 'default' for standard naming."
  type        = string
  default     = "default"
}

variable "cross_account_event_bridge_role_name" {
  description = "Override for the cross-account EventBridge role name. Use 'default' for standard naming."
  type        = string
  default     = "default"
}

variable "cross_account_event_bridge_policy_name" {
  description = "Override for the cross-account EventBridge policy name. Use 'default' for standard naming."
  type        = string
  default     = "default"
}

variable "stackset_auto_deployment" {
  description = "Automatically deploy to new accounts added to the target OUs."
  type        = bool
  default     = true
}

variable "stackset_retain_on_removal" {
  description = "Retain stacks when an account is removed from the OU."
  type        = bool
  default     = false
}
