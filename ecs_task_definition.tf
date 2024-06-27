resource "aws_ecs_task_definition" "console" {
  family                   = "${var.service_name}Console-${local.application_id}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.console_task.arn
  container_definitions = jsonencode([
    {
      name                   = "${var.service_name}Console-${local.application_id}"
      image                  = "${local.console_image_url}"
      cpu                    = 512
      memory                 = 1024
      memoryReservation      = 1024
      readonlyRootFilesystem = true
      environment : [
        { "name" : "IMAGE_VERSION_CONSOLE", "value" : local.image_version_console },
        { "name" : "IMAGE_VERSION_AGENT", "value" : local.image_version_agent },
        { "name" : "AGENT_TASK_DEFINITION_ROLE_ARN", "value" : aws_iam_role.agent_task.arn },
        { "name" : "APP_CONFIG_AGENT_APPLICATION_ID", "value" : local.application_id },
        { "name" : "APP_CONFIG_AGENT_CONFIGURATION_PROFILE_ROLE_ARN", "value" : aws_iam_role.appconfig_agent_configuration_document.arn },
        { "name" : "APP_CONFIG_AGENT_DEPLOYMENT_STRATEGY_ID", "value" : aws_appconfig_deployment_strategy.agent.id },
        { "name" : "APP_CONFIG_AGENT_ENVIRONMENT_ID", "value" : aws_appconfig_environment.agent.environment_id },
        { "name" : "EXECUTION_ROLE_ARN", "value" : aws_iam_role.execution.arn },
        { "name" : "EC2_CONTAINER_ROLE_ARN", "value" : aws_iam_instance_profile.ec2_container.arn },
        { "name" : "CONSOLE_VPC", "value" : var.vpc },
        { "name" : "CONSOLE_SUBNET", "value" : "${var.subnet_a_id},${var.subnet_b_id}" },
        { "name" : "PARAMETER_STORE_NAME_PREFIX", "value" : "/${var.parameter_prefix}-${local.application_id}" },
        { "name" : "CONSOLE_SECURITY_GROUP_ID", "value" : "${var.configure_load_balancer}" ? "${aws_security_group.load_balancer[0].id}" : "${aws_security_group.console[0].id}" },
        { "name" : "AGENT_AUTO_ASSIGN_PUBLIC_IP", "value" : "${var.agent_auto_assign_public_ip}" ? "ENABLED" : "DISABLED" },
        { "name" : "BYOL_MODE", "value" : "False" },
        { "name" : "BLANKET_KMS_ACCESS", "value" : "${tostring(var.allow_access_to_all_kms_keys)}" },
        { "name" : "HAS_LOAD_BALANCER", "value" : "${tostring(var.configure_load_balancer)}" },
        { "name" : "TRUSTED_LOAD_BALANCER_NETWORK", "value" : "${tostring(var.trusted_load_balancer_network)}" },
        { "name" : "INFO_OPT_OUT", "value" : "${tostring(var.info_opt_out)}" },
        { "name" : "QUARANTINE_BUCKET_NAME_PREFIX", "value" : "${var.quarantine_bucket_prefix}-${local.application_id}" },
        { "name" : "DYNAMO_DB_TABLE_NAME_PREFIX", "value" : "${local.application_id}." },
        { "name" : "CLUSTER_NAME", "value" : "${aws_ecs_cluster.main.name}" },
        { "name" : "NOTIFICATIONS_TOPIC_NAME", "value" : aws_sns_topic.notifications.name },
        { "name" : "APP_CONFIG_DOCUMENT_NAME", "value" : awscc_ssm_document.appconfig_document.name },
        { "name" : "APP_CONFIG_DOCUMENT_SCHEMA_NAME", "value" : aws_ssm_document.appconfig_document_schema.name },
        { "name" : "APP_CONFIG_PROFILE_ID", "value" : aws_appconfig_configuration_profile.agent.configuration_profile_id },
        { "name" : "EVENT_BASED_SCAN_TOPIC_NAME", "value" : "${var.service_name}Topic-${local.application_id}" },
        { "name" : "EVENT_BASED_SCAN_QUEUE_NAME", "value" : "${var.service_name}Queue-${local.application_id}" },
        { "name" : "DC_EVENT_BASED_SCAN_QUEUE_NAME", "value" : "${var.service_name}Queue-DC-${local.application_id}" },
        { "name" : "EFS_SCAN_QUEUE_NAME", "value" : "${var.service_name}Queue-EFS-${local.application_id}" },
        { "name" : "RETRO_SCAN_QUEUE_NAME", "value" : "${var.service_name}RetroQueue-${local.application_id}" },
        { "name" : "CONSOLE_TASK_NAME", "value" : "${var.service_name}Console-${local.application_id}" },
        { "name" : "CONSOLE_SERVICE_NAME", "value" : "${var.configure_load_balancer}" ? "${var.service_name}ConsoleService-LB-${local.application_id}" : "${var.service_name}ConsoleService-${local.application_id}" },
        { "name" : "CONSOLE_ROLE_ARN", "value" : aws_iam_role.console_task.arn },
        { "name" : "EVENT_AGENT_TASK_NAME", "value" : "${var.service_name}Agent-${local.application_id}" },
        { "name" : "DC_EVENT_AGENT_TASK_NAME", "value" : "${var.service_name}Agent-DC-${local.application_id}" },
        { "name" : "EVENT_AGENT_SERVICE_NAME", "value" : "${var.service_name}AgentService-${local.application_id}" },
        { "name" : "DC_EVENT_AGENT_SERVICE_NAME", "value" : "${var.service_name}AgentService-DC-${local.application_id}" },
        { "name" : "EFS_AGENT_TASK_NAME", "value" : "${var.service_name}Agent-EFS-${local.application_id}" },
        { "name" : "EBS_AGENT_TASK_NAME", "value" : "${var.service_name}Agent-EBS-${local.application_id}" },
        { "name" : "EBS_DC_AGENT_TASK_NAME", "value" : "${var.service_name}Agent-EBS-DC-${local.application_id}" },
        { "name" : "EC2_SCAN_TASK_NAME", "value" : "${var.service_name}-EC2Scan-${local.application_id}" },
        { "name" : "LARGE_FILE_AGENT_TASK_NAME", "value" : "${var.service_name}LargeFileAgent-${local.application_id}" },
        { "name" : "API_AGENT_TASK_NAME", "value" : "${var.service_name}ApiAgent-${local.application_id}" },
        { "name" : "API_AGENT_SERVICE_NAME", "value" : "${var.service_name}ApiAgentService-${local.application_id}" },
        { "name" : "EFS_AGENT_SERVICE_NAME", "value" : "${var.service_name}EfsAgentService-${local.application_id}" },
        { "name" : "API_LB_NAME", "value" : "${var.service_name}ApiLB-${local.application_id}" },
        { "name" : "API_LB_TG_NAME", "value" : "${var.service_name}ApiTG-${local.application_id}" },
        { "name" : "RETRO_AGENT_TASK_NAME", "value" : "${var.service_name}RetroAgent-${local.application_id}" },
        { "name" : "RETRO_AGENT_SERVICE_NAME", "value" : "${var.service_name}RetroAgentService-${local.application_id}" },
        { "name" : "LARGE_EVENT_QUEUE_ALARM_NAME", "value" : "${var.service_name}LargeQueue-${local.application_id}" },
        { "name" : "SMALL_EVENT_QUEUE_ALARM_NAME", "value" : "${var.service_name}SmallQueue-${local.application_id}" },
        { "name" : "DECREASE_AGENTS_SCALING_POLICY_NAME", "value" : "DecreaseAgents-${local.application_id}" },
        { "name" : "INCREASE_AGENTS_SCALING_POLICY_NAME", "value" : "IncreaseAgents-${local.application_id}" },
        { "name" : "LARGE_DC_EVENT_QUEUE_ALARM_NAME", "value" : "${var.service_name}LargeQueue-DC-${local.application_id}" },
        { "name" : "SMALL_DC_EVENT_QUEUE_ALARM_NAME", "value" : "${var.service_name}SmallQueue-DC-${local.application_id}" },
        { "name" : "DECREASE_DC_AGENTS_SCALING_POLICY_NAME", "value" : "DecreaseAgents-DC-${local.application_id}" },
        { "name" : "INCREASE_DC_AGENTS_SCALING_POLICY_NAME", "value" : "IncreaseAgents-DC-${local.application_id}" },
        { "name" : "API_REQUEST_SCALING_POLICY_NAME", "value" : "${var.api_request_scaling_policy_prefix}-${local.application_id}" },
        { "name" : "API_CPU_SCALING_POLICY_NAME", "value" : "ApiServiceCpuScaling-${local.application_id}" },
        { "name" : "RETRO_QUEUE_NOT_EMPTY_ALARM_NAME", "value" : "${var.service_name}RetroQueueNotEmpty-${local.application_id}" },
        { "name" : "RETRO_QUEUE_EMPTY_ALARM_NAME", "value" : "${var.service_name}RetroQueueEmpty-${local.application_id}" },
        { "name" : "REMOVE_RETRO_AGENTS_SCALING_POLICY_NAME", "value" : "RemoveRetroAgents-${local.application_id}" },
        { "name" : "SET_RETRO_AGENTS_SCALING_POLICY_NAME", "value" : "SetRetroAgents-${local.application_id}" },
        { "name" : "AGENT_SECURITY_GROUP_NAME", "value" : "${var.service_name}AgentSecurityGroup-${local.application_id}" },
        { "name" : "EFS_SCAN_SECURITY_GROUP_NAME", "value" : "${var.service_name}EFSScan-${local.application_id}" },
        { "name" : "EBS_SCAN_SECURITY_GROUP_NAME", "value" : "${var.service_name}EBSScan-${local.application_id}" },
        { "name" : "FSX_SCAN_SECURITY_GROUP_NAME", "value" : "${var.service_name}FSxScan-${local.application_id}" },
        { "name" : "CROSS_ACCOUNT_ROLE_NAME", "value" : local.cross_account_role_name },
        { "name" : "CROSS_ACCOUNT_POLICY_NAME", "value" : local.cross_account_policy_name },
        { "name" : "CROSS_ACCOUNT_EVENT_BRIDGE_ROLE_NAME", "value" : local.event_bridge_role_name },
        { "name" : "CROSS_ACCOUNT_EVENT_BRIDGE_POLICY_NAME", "value" : aws_iam_policy.event_bridge.name },
        { "name" : "CUSTOM_RESOURCE_TAGS", "value" : join(",", [for key, value in var.custom_resource_tags : "${key}=${value}"]) },
        { "name" : "DLP_CCL_DIR", "value" : "/cssdlp" },
        { "name" : "DLP_CCL_FILE_NAME", "value" : "PredefinedContentControlLists.xml" },
        { "name" : "PROXY_HOST", "value" : "${local.use_proxy}" ? "${var.proxy_host}" : "" },
        { "name" : "PROXY_PORT", "value" : "${local.use_proxy}" ? "${var.proxy_port}" : "" },
        { "name" : "PRODUCT_MODE", "value" : "${local.product_mode}" },
        { "name" : "TEMPLATE_VARIATION", "value" : "default" },
        { "name" : "DEPLOYMENT_TYPE", "value" : "terraform" },
        { "name" : "BUCKETS_TO_PROTECT", "value" : "${var.buckets_to_protect}" },
        { "name" : "LOG_LEVEL", "value" : "Info" },
        { "name" : "APPLICATION_BUCKET_NAME", "value" : aws_s3_bucket.application.id },
        { "name" : "RETRY_COUNT", "value" : "5" },
        { "name" : "RETRY_MEDIAN_JITTER_DELAY", "value" : "1" },
        { "name" : "AWS_BEDROCK_ENABLED", "value" : "${tostring(var.aws_bedrock_enabled)}" },
        { "name" : "ENABLED_REGIONS", "value" : "" },
      ]
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
      LogConfiguration = {
        LogDriver = "awslogs"
        Options = {
          awslogs-group         = aws_cloudwatch_log_group.main.name
          awslogs-region        = local.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      HealthCheck = {
        Command = [
          "CMD-SHELL",
          "curl -k -f https://localhost/api/health || exit 1"
        ]
        Interval = 60
        Timeout  = 5
        Retries  = 3
      }
    }
  ])
  tags = merge({ (local.application_tag_key) = "ConsoleTaskDefinition" },
    var.custom_resource_tags
  )
}
