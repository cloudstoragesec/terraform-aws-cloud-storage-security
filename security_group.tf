resource "aws_security_group" "console" {
  count       = var.configure_load_balancer ? 0 : 1
  name        = "${var.service_name}ConsoleSecurityGroup-${local.application_id}"
  description = "${var.service_name}ConsoleSecurityGroup-${local.application_id}"
  vpc_id      = var.vpc

  ingress {
    description = "CloudStorageSec Console port 80 ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }
  ingress {
    description = "CloudStorageSec Console port 443 ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "CloudStorageSec Console default egress to internet"
  }

  tags = merge({ (local.application_tag_key) = "SecurityGroup" },
    var.custom_resource_tags
  )
}

resource "aws_security_group" "console_with_load_balancer" {
  count       = var.configure_load_balancer ? 1 : 0
  name        = "${var.service_name}ContainerSecurityGroupWithLB-${local.application_id}"
  description = "${var.service_name}ContainerSecurityGroupWithLB-${local.application_id}"
  vpc_id      = var.vpc

  ingress {
    description     = "CloudStorageSec Console port 80 ingress"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.load_balancer[0].id}"]
  }
  ingress {
    description     = "CloudStorageSec Console port 443 ingress"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.load_balancer[0].id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "CloudStorageSec Console default egress to internet"
  }

  tags = merge({ (local.application_tag_key) = "SecurityGroup" },
    var.custom_resource_tags
  )
}

resource "aws_security_group" "load_balancer" {
  count       = var.configure_load_balancer ? 1 : 0
  name = "${var.service_name}LoadBalancerSecurityGroup-${local.application_id}"
  description = "${var.service_name}LoadBalancerSecurityGroup-${local.application_id}"
  vpc_id      = var.vpc

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "CloudStorageSec Console default egress to internet"
  }
  tags = merge({ (local.application_tag_key) = "SecurityGroup" },
    var.custom_resource_tags
  )
}

