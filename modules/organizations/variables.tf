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
