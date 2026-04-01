locals {
  vpc_endpoint_sg_ids  = var.create_vpc_endpoints ? [aws_security_group.vpc_endpoints[0].id] : []
  vpc_endpoint_subnets = var.create_vpc_endpoints ? [var.subnet_a_id, var.subnet_b_id] : []

  # Interface endpoint service names
  interface_endpoint_services = var.create_vpc_endpoints ? {
    ecr_api       = "com.amazonaws.${local.aws_region}.ecr.api"
    ecr_dkr       = "com.amazonaws.${local.aws_region}.ecr.dkr"
    ssm           = "com.amazonaws.${local.aws_region}.ssm"
    sqs           = "com.amazonaws.${local.aws_region}.sqs"
    sns           = "com.amazonaws.${local.aws_region}.sns"
    logs          = "com.amazonaws.${local.aws_region}.logs"
    appconfig     = "com.amazonaws.${local.aws_region}.appconfig"
    appconfigdata = "com.amazonaws.${local.aws_region}.appconfigdata"
    cognito_idp   = "com.amazonaws.${local.aws_region}.cognito-idp"
    kms           = "com.amazonaws.${local.aws_region}.kms"
    secretsmanager = "com.amazonaws.${local.aws_region}.secretsmanager"
    sts           = "com.amazonaws.${local.aws_region}.sts"
    monitoring    = "com.amazonaws.${local.aws_region}.monitoring"
  } : {}
}

# -------------------------------------------------------
# Interface VPC Endpoints
# -------------------------------------------------------

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_endpoint_services

  vpc_id              = var.vpc
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.vpc_endpoint_subnets
  security_group_ids  = local.vpc_endpoint_sg_ids
  private_dns_enabled = true

  tags = merge(
    { (local.application_tag_key) = "VpcEndpoint-${each.key}" },
    var.custom_resource_tags
  )
}

# -------------------------------------------------------
# Gateway VPC Endpoints (S3 and DynamoDB)
# Route table association is required — skipped when
# vpc_endpoint_route_table_ids is empty.
# -------------------------------------------------------

resource "aws_vpc_endpoint" "s3" {
  count = var.create_vpc_endpoints && length(var.vpc_endpoint_route_table_ids) > 0 ? 1 : 0

  vpc_id            = var.vpc
  service_name      = "com.amazonaws.${local.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.vpc_endpoint_route_table_ids

  tags = merge(
    { (local.application_tag_key) = "VpcEndpoint-s3" },
    var.custom_resource_tags
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.create_vpc_endpoints && length(var.vpc_endpoint_route_table_ids) > 0 ? 1 : 0

  vpc_id            = var.vpc
  service_name      = "com.amazonaws.${local.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.vpc_endpoint_route_table_ids

  tags = merge(
    { (local.application_tag_key) = "VpcEndpoint-dynamodb" },
    var.custom_resource_tags
  )
}
