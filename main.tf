terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.1"
    }
  }
}

resource "aws_appautoscaling_target" "main" {
  max_capacity       = 1
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${local.ecs_service_name}"
  role_arn           = "arn:${data.aws_partition.current.partition}:iam::${local.account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  tags = merge({ (join("-", ["${var.service_name}", "${local.application_id}"])) = "ConsoleAutoScaling" },
    var.custom_resource_tags
  )
  depends_on = [aws_ecs_service.main, aws_ecs_service.with_load_balancer]
}