
resource "random_id" "stack" {
  byte_length = 4
}

resource "aws_appconfig_application" "agent" {
  name        = "${var.service_name}-${random_id.stack.hex}"
  description = "AppConfig Application for CloudStorageSec Agents"
  tags = merge({ (join("-", ["${var.service_name}", "${random_id.stack.hex}"])) = "ConsoleAppConfig" },
    var.custom_resource_tags
  )
}

resource "aws_appconfig_environment" "agent" {
  name           = "${var.service_name}Env-${local.application_id}"
  description    = "AppConfig Environment for CloudStorageSec Agents"
  application_id = local.application_id
  tags = merge({ "${local.application_tag_key}" = "ConfigEnvironment" },
    var.custom_resource_tags
  )
}

resource "aws_appconfig_deployment_strategy" "agent" {
  name                           = "${var.service_name}ConfigDeploy-${local.application_id}"
  description                    = "AppConfig Deployment Strategy for CloudStorageSec Agents"
  deployment_duration_in_minutes = 0
  final_bake_time_in_minutes     = 0
  growth_factor                  = 100
  growth_type                    = "LINEAR"
  replicate_to                   = "NONE"

  tags = merge({ "${local.application_tag_key}" = "ConfigStartegy" },
    var.custom_resource_tags
  )
}

resource "aws_ssm_document" "appconfig_document_schema" {
  name            = "${var.service_name}Config-Schema-${local.application_id}"
  document_type   = "ApplicationConfigurationSchema"
  document_format = "JSON"
  content         = file("${path.module}/appconfig_schema.json")

  tags = merge({ "${local.application_tag_key}" = "ConfigSchema" },
    var.custom_resource_tags
  )
}

resource "awscc_ssm_document" "appconfig_document" {
  name            = "${var.service_name}Config-Doc-${local.application_id}"
  document_type   = "ApplicationConfiguration"
  document_format = "JSON"

  requires = [
    {
      name    = "${aws_ssm_document.appconfig_document_schema.name}"
      version = "$LATEST"
    }
  ]

  lifecycle {
    ignore_changes = [
      # TF Tries to update tags every time and Cloud Control call times out if they are the same.
      tags,
      requires,
      content
    ]
  }

  content = templatefile("${path.module}/appconfig_doc.json", {
    app_id = local.application_id
  })
  tags = concat([
    {
      key   = local.application_tag_key
      value = "ConfigDoc"
    },
  ], [for tag, val in var.custom_resource_tags : { key = tag, value = val }])
}

resource "time_sleep" "wait_30_for_policy" {
  depends_on      = [aws_iam_role_policy.appconfig_agent_configuration_document]
  create_duration = "30s"
}
# Trying to use the role immediately results in AccessDeniedException. Small delay fixes that.
resource "aws_appconfig_configuration_profile" "agent" {
  application_id     = local.application_id
  description        = "AppConfig profile for CloudStorageSec Agents"
  name               = "${var.service_name}Config-Profile-${local.application_id}"
  location_uri       = "ssm-document://${awscc_ssm_document.appconfig_document.name}"
  retrieval_role_arn = aws_iam_role.appconfig_agent_configuration_document.arn
  tags = merge({ "${local.application_tag_key}" = "ConfigProfile" },
    var.custom_resource_tags
  )
  depends_on = [time_sleep.wait_30_for_policy]
}

resource "aws_appconfig_deployment" "agent" {
  application_id           = local.application_id
  configuration_profile_id = aws_appconfig_configuration_profile.agent.configuration_profile_id
  configuration_version    = 1
  deployment_strategy_id   = aws_appconfig_deployment_strategy.agent.id
  description              = "AppConfig Deployment for CloudStorageSec Agents"
  environment_id           = aws_appconfig_environment.agent.environment_id

  tags = merge({ "${local.application_tag_key}" = "ConfigDeployment" },
    var.custom_resource_tags
  )
}
