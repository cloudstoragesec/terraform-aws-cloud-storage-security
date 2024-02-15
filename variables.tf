variable "vpc" {
  description = "The VPC in which to place the user facing Console"
}

variable "cidr" {
  description = "The CIDR block which is allowed access to the CSS Console (e.g. 0.0.0.0/24 for open access)"
}

variable "subnet_a_id" {
  description = "A subnet ID within the VPC that may be used for ECS tasks for this deployment"
}

variable "subnet_b_id" {
  description = "A second subnet ID within the VPC that may be used for ECS tasks for this deployment. We recommend choosing subnets in different availability zones"
}

variable "email" {
  description = "The email address to be used for the initial admin account created for the CSS Console"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_account" {
  description = "The AWS account number where resources are being deployed. Defaults to the effective Account ID in which Terraform is authorized if not set."
  default     = null
}

variable "username" {
  description = "The username to be used for the initial user created for accessing the CSS Console"
  type        = string
  default     = "admin"
}

variable "buckets_to_protect" {
  description = "Enter any pre-existing buckets that you would like to automatically enable event-based protection on. Bucket names must be separated by commas (e.g. bucket1,bucket2,bucket3). Protected buckets can be managed after deployment in the CSS Console."
  type        = string
  default     = ""
}

variable "configure_load_balancer" {
  description = "Whether the Console should be deployed behind a load balancer. Recommended if deploying the Console in private subnets."
  type        = bool
  default     = false
}

variable "existing_target_group_arn" {
  description = "If you are using your own AWS load balancer, provide the Target Group ARN that the Console service should register with. If configured, 'configure_load_balancer' must be 'true', and 'trusted_load_balancer_network' must be specified."
  type        = string
  default     = null
}

variable "lb_cert_arn" {
  description = "The certificate arn to use for the load balancer. Required if `configure_load_balancer` is true"
  type        = string
  default     = null
}

variable "trusted_load_balancer_network" {
  description = "If you are using your own load balancer or other appliance to forward traffic to the Console, enter the trusted IP address range (CIDR notation) that will be routing traffic to the Console. Leave blank if you are not supplying your own load balancer."
  type        = string
  default     = ""
}

variable "internal_lb" {
  description = "If true, the load balancer will be internal. internet facing otherwise"
  type        = bool
  default     = false
}

variable "agent_scanning_engine" {
  description = "The scanning engine to use. ClamAV is included with no additional charges. Premium engines such as `Sophos` incurr an additional licensing charge per GB (see Marketplace listing for pricing) Valid values: `ClamAV`, `Sophos`"
  type        = string
  default     = "ClamAV"
}

variable "multi_engine_scanning_mode" {
  description = "Whether or not multiple av engines should be utilized to scan files. If this is enabled, the `agent_scanning_engine` variable must be set to `Sophos`. When set to `All`, every file will be scanned by both engines. When set to `LargeFiles`, only files larger than 2GB will be scanned with `Sophos`, and 2GB and smaller will be scanned with `ClamAV`. Valid values: `Disabled`, `All`, `LargeFiles`"
  type        = string
  default     = "Disabled"
}

variable "info_opt_out" {
  description = "Would you like to opt-out from sending statistics to Cloud Storage Security? This is performed via an API call to an AWS Lambda in CSS' AWS Account. No sensitive information is ever sent to CSS. This option should only be set to false if you are deploying behind a load balancer, as it would prevent us from registering a friendly DNS address for your deployment. Without a DNS address, the only way to reach the console would be to get the IP address from ECS each time the console task is restarted. Selecting 'Yes' will cause custom DNS registration and trial eligibility checks to not work. Given this, you must use your own Load Balancer to opt-out. If you opt-out and still would like a trial, please contact support@cloudstoragesec.com."
  type        = bool
  default     = false
}

variable "custom_resource_tags" {
  description = "Map of custom tags to apply to resources. Example: {\"CustomTag_A\" = \"Value A\"\"CustomTag_B\" = \"Value B\"}"
  type        = map(string)
  default     = {}
}

variable "ecr_account" {
  description = "The AWS Account ID which contains the ECR repositories used for the CSS Console and Agent images. If customized, you must ensure that you have replicated the appropriate images to repositories in the specified account, and the repository names must be `cloudstoragesecurity/console` and `cloudstoragesecurity/agent`"
  type        = string
  default     = null
}

variable "dynamo_cmk_key_arn" {
  description = "Optional ARN for the CMK that should be used for the AWS KMS encryption if the key is different from the default KMS-managed DynamoDB key. Cloud Storage Security Console and Agent IAM Roles will be given permission to use this key."
  type        = string
  default     = null
}

variable "sns_cmk_key_arn" {
  description = "Optional ARN for the CMK that should be used for the AWS KMS encryption for Notifications SNS topic Cloud Storage Security Console and Agent IAM Roles will be given permission to use this key."
  type        = string
  default     = null
}

variable "console_auto_assign_public_ip" {
  description = "Whether a public IP should be assigned to the console. If set to false, there will need to be a proxy, nat gateway, or other mechanism in place to allow the Console to reach AWS services. You may configure VPC Endpoints for most AWS services we utilize, but a few do not yet support VPC Endpoints. (WARNING: do not set to disabled unless you have configured your AWS VPC in a manner that would still allow access to the console.)"
  type        = bool
  default     = true
}

variable "agent_auto_assign_public_ip" {
  description = "Should public IPs be assigned to the Agents? (WARNING: do not set to disabled unless you have configured your AWS VPC in a manner that would still allow the agents to reach AWS services over the internet.)"
  type        = bool
  default     = true
}

variable "allow_access_to_all_kms_keys" {
  description = "Pick true if you would like to give the scanner access to all KMS encrypted buckets"
  type        = bool
  default     = true
}

variable "proxy_host" {
  description = "URL for proxy server"
  type        = string
  default     = null
}

variable "proxy_port" {
  description = "Port for proxy server"
  type        = string
  default     = null
}

variable "eventbridge_notifications_enabled" {
  description = "If true Proactive Notifications will also be sent to AWS EventBridge"
  type        = bool
  default     = false
}

variable "eventbridge_notifications_bus_name" {
  description = "Enter the EventBridge bus name to use for notifications, if desired to be one other than default."
  type        = string
  default     = "default"
}

variable "event_bridge_role_name" {
  description = "Optional Role name for the AWS AWS Event Bridge execution. A default one will be created if not set."
  type        = string
  default     = null
}

variable "service_name" {
  description = "A prefix to place on resources that this Terraform template creates. May be overriden if there is an organizational standard for resource name prefixes that needs to be followed. values: any string, but should be short to avoid possibly attempting to create resources with names that exceed the max allowed length"
  type        = string
  default     = "CloudStorageSec"
}

variable "parameter_prefix" {
  description = "Prefix for SSM Parameters"
  type        = string
  default     = "CloudStorageSecConsole"
}

variable "quarantine_bucket_prefix" {
  description = "Prefix for the quarantine bucket"
  type        = string
  default     = "cloudstoragesecquarantine"
}

variable "api_request_scaling_policy_prefix" {
  description = "Prefix for the AutoScaling policy for the API Service."
  type        = string
  default     = "ApiServiceRequestScaling"
}