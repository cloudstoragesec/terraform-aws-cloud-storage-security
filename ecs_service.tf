resource "aws_ecs_cluster" "main" {
  name = "${var.service_name}Cluster-${local.application_id}"
  tags = merge({ "${local.application_tag_key}" = "ConsoleCluster" },
    var.custom_resource_tags
  )
}

resource "aws_ecs_service" "main" {
  name                               = local.ecs_service_name
  count                              = var.configure_load_balancer ? 0 : 1
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.console.arn
  desired_count                      = 1
  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  network_configuration {
    subnets          = [var.subnet_a_id, var.subnet_b_id]
    security_groups  = [aws_security_group.console[0].id]
    assign_public_ip = var.console_auto_assign_public_ip
  }
  tags = merge({ "${local.application_tag_key}" = "ConsoleService" },
    var.custom_resource_tags
  )
  lifecycle {
    precondition {
      condition     = var.subnet_a_id != var.subnet_b_id
      error_message = "Subnet A and Subnet B must be different"
    }
  }
}


resource "aws_ecs_service" "with_load_balancer" {
  count                              = var.configure_load_balancer ? 1 : 0
  name                               = local.ecs_service_name
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.console.arn
  desired_count                      = 1
  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  load_balancer {
    target_group_arn = var.existing_target_group_arn == null ? aws_lb_target_group.main[0].arn : var.existing_target_group_arn
    container_name   = "${var.service_name}Console-${local.application_id}"
    container_port   = 443
  }

  network_configuration {
    subnets          = [var.subnet_a_id, var.subnet_b_id]
    security_groups  = [aws_security_group.console_with_load_balancer[0].id]
    assign_public_ip = var.console_auto_assign_public_ip
  }
  tags = merge({ "${local.application_tag_key}" = "ConsoleService" },
    var.custom_resource_tags
  )

  lifecycle {
    precondition {
      condition     = var.existing_target_group_arn == null || !var.configure_load_balancer && var.trusted_load_balancer_network != ""
      error_message = "`configure_load_balancer` must be `true`, and `trusted_load_balancer_network` must be specified when `existing_target_group_arn` is set."
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
  tags = merge({ "${local.application_tag_key}" = "ConsoleAutoScaling" },
    var.custom_resource_tags
  )
  depends_on = [aws_ecs_service.main, aws_ecs_service.with_load_balancer]
}

resource "aws_lb_target_group" "main" {
  count    = var.configure_load_balancer && var.existing_target_group_arn == null ? 1 : 0
  name     = "${var.service_name}TG-LB-${local.application_id}"
  port     = "443"
  protocol = "HTTPS"
  health_check {
    protocol = "HTTPS"
    port     = "443"
    path     = "/Account/SignIn"
    interval = "300"
    timeout  = "120"
  }
  target_type          = "ip"
  vpc_id               = var.vpc
  deregistration_delay = 60
  tags = merge({ "${local.application_tag_key}" = "ConsoleTargetGroup" },
    var.custom_resource_tags
  )
}

resource "aws_lb_listener" "main" {
  count             = var.configure_load_balancer && var.existing_target_group_arn == null ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = var.lb_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
  tags = merge({ "${local.application_tag_key}" = "ConsoleListener" },
    var.custom_resource_tags
  )

  lifecycle {
    precondition {
      condition     = var.configure_load_balancer && var.lb_cert_arn != null
      error_message = "`lb_cert_arn` is required when `configure_load_balancer` is true."
    }
  }
}

resource "aws_lb" "main" {
  count              = var.configure_load_balancer && var.existing_target_group_arn == null ? 1 : 0
  name               = "${var.service_name}LB-${local.application_id}"
  idle_timeout       = 60
  internal           = var.internal_lb
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer[0].id]
  subnets            = local.use_lb_subnets ? [var.lb_subnet_a_id, var.lb_subnet_b_id] : [var.subnet_a_id, var.subnet_b_id]
  tags = merge({ "${local.application_tag_key}" = "ConsoleLoadBalancer" },
    var.custom_resource_tags
  )
  lifecycle {
    precondition {
      condition     = !local.use_lb_subnets || var.lb_subnet_a_id != var.lb_subnet_b_id
      error_message = "Load Balancer Subnet A and Subnet B must be different"
    }
  }
}