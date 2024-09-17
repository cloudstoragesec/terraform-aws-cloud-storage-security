variable "vpc" {
  description = "The VPC in which to place the user facing Console"
}

variable "cidr" {
  type        = list(string)
  description = "The CIDR blocks which are allowed access to the CSS Console (e.g. 0.0.0.0/0 for open access)"
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
  description = <<EOF
    Enter any pre-existing buckets that you would like to automatically enable event-based protection on.
    Bucket names must be separated by commas (e.g. bucket1,bucket2,bucket3). Protected buckets can be managed after deployment in the CSS Console.
  EOF
  type        = string
  default     = ""
}

variable "configure_load_balancer" {
  description = "Whether the Console should be deployed behind a load balancer. Recommended if deploying the Console in private subnets."
  type        = bool
  default     = false
}

variable "existing_target_group_arn" {
  description = <<EOF
    If you are using your own AWS load balancer, provide the Target Group ARN that the Console service should register with.
    If configured, 'configure_load_balancer' must be 'true', and 'trusted_load_balancer_network' must be specified.
  EOF
  type        = string
  default     = null
}

variable "lb_cert_arn" {
  description = "The certificate arn to use for the load balancer. Required if `configure_load_balancer` is true"
  type        = string
  default     = null
}

variable "trusted_load_balancer_network" {
  description = <<EOF
    If you are using your own load balancer or other appliance to forward traffic to the Console,
    enter the trusted IP address range (CIDR notation) that will be routing traffic to the Console.
    Leave blank if you are not supplying your own load balancer.
  EOF
  type        = string
  default     = ""
}

variable "lb_subnet_a_id" {
  description = <<EOF
    A subnet in your VPC in which the Load Balancer can be placed. Ensure this subnet allows outbound internet traffic.
    ** Leave blank to use same subnet as Console. If specified, must be in same AZ as Console subnet. **
  EOF
  type        = string
  default     = null
}

variable "lb_subnet_b_id" {
  description = <<EOF
    A subnet in your VPC in which the Load Balancer can be placed. Ensure this subnet allows outbound internet traffic.
    **Subnet B must be different from Subnet A and should be in a different Availability Zones. Leave blank to use same subnet as Console.
    If specified, must be in same AZ as Console subnet. **
  EOF
  type        = string
  default     = null
}

variable "internal_lb" {
  description = "If true, the load balancer will be internal. internet facing otherwise"
  type        = bool
  default     = false
}

variable "min_running_agents" {
  description = <<EOF
  Initial default minimum number of running scan agents per region
  This value represents the initial setting upon deployment and can be modified via the console's UI after the initial deployment using Terraform.
  EOF
  type        = number
  default     = 1
}

variable "max_running_agents" {
  description = <<EOF
  Default maximum number of running scan agents per region.
  This value represents the initial setting upon deployment and can be modified via the console's UI after the initial deployment using Terraform.
  EOF
  type        = number
  default     = 12
}

variable "enable_large_file_scanning" {
  description = <<EOF
  Set to true if you would like to have EC2 instances launched to scan files too large to be scanned by the normal agent
  This value represents the initial setting upon deployment and can be modified via the console's UI after the initial deployment using Terraform.
  EOF
  type        = bool
  default     = false
}

variable "large_file_disk_size_gb" {
  description = <<EOF
    Choose a larger disk size (between 20 - 16,300 GB) to enable scanning larger files, up to 5 GB fewer than the total disk size.
    This only applies when using the Sophos scanning engine with EC2 large file scanning enabled.
    This value represents the initial setting upon deployment and can be modified via the console's UI after the initial deployment using Terraform.
  EOF
  type        = number
  default     = 2000
}

variable "agent_scanning_engine" {
  description = <<EOF
    The initial scanning engine to use. ClamAV is included with no additional charges.
    Premium engines such as `Sophos` incur an additional licensing charge per GB (see Marketplace listing for pricing) Valid values: `ClamAV`, `Sophos`
    This value represents the initial setting upon deployment and can be modified via the console's UI after the initial deployment using Terraform.
  EOF
  type        = string
  default     = "ClamAV"
}

variable "multi_engine_scanning_mode" {
  description = <<EOF
    Initial setting for whether or not multiple av engines should be utilized to scan files. If this is enabled, the `agent_scanning_engine` variable must be set to `Sophos`.
    When set to `All`, every file will be scanned by both engines.
    When set to `LargeFiles`, only files larger than 2GB will be scanned with `Sophos`, and 2GB and smaller will be scanned with `ClamAV`.
    Valid values: `Disabled`, `All`, `LargeFiles`
    This value represents the initial setting upon deployment and can be modified via the console's UI after the initial deployment using Terraform.
  EOF
  type        = string
  default     = "Disabled"
}

variable "info_opt_out" {
  description = <<EOF
    Would you like to opt-out from sending statistics to Cloud Storage Security?
    This is performed via an API call to an AWS Lambda in CSS' AWS Account. No sensitive information is ever sent to CSS.
    This option should only be set to `false` if you are deploying behind a load balancer, as it would prevent us from registering a friendly DNS address for your deployment.
    Without a DNS address, the only way to reach the console would be to get the IP address from ECS each time the console task is restarted.
    Selecting `true` will cause custom DNS registration and trial eligibility checks to not work. Given this, you must use your own Load Balancer to opt-out.
    If you opt-out and still would like a trial, please contact support@cloudstoragesec.com.
  EOF
  type        = bool
  default     = false
}

variable "custom_resource_tags" {
  description = "Map of custom tags to apply to resources. Example: {\"CustomTag_A\" = \"Value A\",\"CustomTag_B\" = \"Value B\"}"
  type        = map(string)
  default     = {}
}

variable "ecr_account" {
  description = <<EOF
    The AWS Account ID which contains the ECR repositories used for the CSS Console and Agent images.
    If customized, you must ensure that you have replicated the appropriate images to repositories in the specified account,
    and the repository names must be `cloudstoragesecurity/console` and `cloudstoragesecurity/agent`
  EOF
  type        = string
  default     = null
}

variable "dynamo_cmk_key_arn" {
  description = <<EOF
    Optional ARN for the CMK that should be used for the AWS KMS encryption if the key is different from the default KMS-managed DynamoDB key.
    Cloud Storage Security Console and Agent IAM Roles will be given permission to use this key.
  EOF
  type        = string
  default     = null
}

variable "sns_cmk_key_arn" {
  description = <<EOF
    Optional ARN for the CMK that should be used for the AWS KMS encryption for Notifications SNS topic.
    Cloud Storage Security Console and Agent IAM Roles will be given permission to use this key.
  EOF
  type        = string
  default     = null
}

variable "console_auto_assign_public_ip" {
  description = <<EOF
    Whether a public IP should be assigned to the console.
    If set to false, there will need to be a proxy, nat gateway, or other mechanism in place to allow the Console to reach AWS services.
    You may configure VPC Endpoints for most AWS services we utilize, but a few do not yet support VPC Endpoints.
    (WARNING: do not set to disabled unless you have configured your AWS VPC in a manner that would still allow access to the console.)
  EOF
  type        = bool
  default     = true
}

variable "agent_auto_assign_public_ip" {
  description = <<EOF
    Should public IPs be assigned to the Agents?
    (WARNING: do not set to disabled unless you have configured your AWS VPC in a manner that would still allow the agents to reach AWS services over the internet.)
  EOF
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

variable "guard_duty_s3_integration_enabled_regions" {
  description = <<EOF
  If you are utilizing GuardDuty S3 Malware scanning, you may enable an integration with CSS. To enable, specify the regions to enable, pipe-delimited. Example: "us-east-1|us-west-2|ca-central-1|eu-west-1"
  EOF
  type        = string
  default     = "DISABLED"
}

variable "guard_duty_s3_malware_result_types" {
  description = <<EOF
  Choose the GuardDuty S3 Malware result types that should be processed.
  Note: Only applicable if `guard_duty_s3_integration_enabled_regions` is not `DISABLED`
  Valid Values: "All Scan Results", "Infected Only"
  EOF
  type        = string
  default     = "All Scan Results"
}

variable "guard_duty_s3_malware_additional_scanning" {
  description = <<EOF
  Choose whether or not you would like perform an additional scan on GuardDuty S3 Malware findings with the CSS engines configured.
  Note: Only applicable if `guard_duty_s3_integration_enabled_regions` is not `DISABLED`
  EOF
  type        = bool
  default     = true
}

variable "retro_scan_on_detected_infection" {
  description = <<EOF
  Choose if you would like CSS to perform a scan on all unscanned files in a bucket when we identify malware in that bucket.
  This is a global setting and applies for any method of scanning files in S3 that we provide.
  EOF
  type        = bool
  default     = false
}

variable "eventbridge_notifications_enabled" {
  description = <<EOF
  If true Proactive Notifications will also be sent to AWS EventBridge
  This value represents the initial setting upon deployment and can be modified via the console's UI after the initial deployment using Terraform.
  EOF
  type        = bool
  default     = false
}

variable "eventbridge_notifications_bus_name" {
  description = <<EOF
  Enter the EventBridge bus name to use for notifications, if desired to be one other than default.
  This value represents the initial setting upon deployment and can be modified via the console's UI after the initial deployment using Terraform.
  EOF
  type        = string
  default     = "default"
}

variable "event_bridge_role_name" {
  description = "Optional Role name for the AWS AWS Event Bridge execution. A default one will be created if not set."
  type        = string
  default     = null
}

variable "service_name" {
  description = <<EOF
    A prefix to place on resources that this Terraform template creates.
    May be overriden if there is an organizational standard for resource name prefixes that needs to be followed.
    values: any string, but should be short to avoid possibly attempting to create resources with names that exceed the max allowed length
  EOF
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

variable "application_bucket_prefix" {
  description = "Prefix for the main application bucket name"
  type        = string
  default     = "cloudstoragesec"
}

variable "api_request_scaling_policy_prefix" {
  description = "Prefix for the AutoScaling policy for the API Service."
  type        = string
  default     = "ApiServiceRequestScaling"
}

variable "aws_bedrock_enabled" {
  description = "Set to true if you would like to use Aws Bedrock features"
  type        = bool
  default     = false
}

variable "set_log_group_retention_policy" {
  description = "Whether we should set a retention policy on CSS created log groups. AWS Landing Zone Accelerator environments must set this to false."
  type        = bool
  default     = true
}

variable "product_mode" {
  description = "Set to true if you would like to use Aws Bedrock features"
  type        = string
  default     = "AV"
  validation {
    condition     = contains(["AV", "DC", "Both"], var.product_mode)
    error_message = "product_type must be one of 'AV', 'DC', 'Both'."
  }
}

variable "product_listing" {
  description = "Set to true if you would like to use Aws Bedrock features"
  type        = string
  default     = "AV"
  validation {
    condition     = contains(["AV", "DC", "S3", "MFT", "DLP", "EFS", "GenAi"], var.product_listing)
    error_message = "product_type must be one of 'AV', 'DC', 'S3', 'MFT', 'DLP', 'EFS', 'GenAi'."
  }
}

variable "sns_topic_policy_override_policy_documents" {
  description = <<EOT
    List of IAM policy documents that are merged together into the default SNS 'Notifications' Topic.
    Passed in via `override_policy_documents` in `aws_iam_policy_document` data source.
    Users should omit definition of the `resources` attribute in statement(s) as the module will
    set resources to target only the 'Notifications' SNS topic.
    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#override_policy_documents
  EOT
  type        = list(string)
  default     = []
}
