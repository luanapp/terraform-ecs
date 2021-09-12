locals {
  # The name of the CloudFormation stack to be created for the VPC and related resources
  aws_vpc_stack_name = "${var.aws_resource_prefix}-vpc-stack"

  # The name of the CloudFormation stack to be created for the ECS service and related resources
  aws_ecs_service_stack_name = "${var.aws_resource_prefix}-svc-stack"

  # The name of the ECR repository to be created
  aws_ecr_repository_name = var.aws_resource_prefix

  # The name of the ECS cluster to be created
  aws_ecs_cluster_name = "${var.aws_resource_prefix}-cluster"

  # The name of the ECS service to be created
  aws_ecs_service_name = "${var.aws_resource_prefix}-service"

  # The name of the execution role to be created
  aws_ecs_execution_role_name = "${var.aws_resource_prefix}-ecs-execution-role"

  # Execution environment for the plan
  environment = var.environment
}

# VPC in which containers will be networked.
# It has two public subnets
# We distribute the subnets across the first two available subnets
# for the region, for high availability.
module "turing_vpc" {
  source = "./modules/aws/vpc"

  vpc_cidr_block           = var.aws_vpc_cidr_block
  subnet_count             = 2
  aws_resource_prefix      = var.aws_resource_prefix
  vpc_enable_dns_hostnames = true

  tags = {
    "environment" = local.environment
  }
}

# A security group for the containers we will run in Fargate.
# Two rules, allowing network traffic from a public facing load
# balancer and from other members of the security group.
#
# Remove any of the following ingress rules that are not needed.
# If you want to make direct requests to a container using its
# public IP address you'll need to add a security group rule
# to allow traffic from all IP addresses.
module "turing_fargate_sg" {
  source = "./modules/aws/security_group"

  vpc_id              = module.turing_vpc.vpc_id
  aws_resource_prefix = var.aws_resource_prefix
  asg_name            = "FargateContainerSecurityGroup"
  asg_description     = "Access to the Fargate containers"

  # Since it will be created a default ASG with ingress inside de group
  # We'll create only one rule here, for the ALB
  asg_rules = {
    "ALB" = {
      type                     = "ingress"
      description              = "Ingress from the public ALB"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      cidr_blocks              = null
      self                     = null
      source_security_group_id = module.turing_public_elb_sg.sg_id
    }
  }

  tags = {
    "environment" = local.environment
  }
}

module "turing_public_elb_sg" {
  source = "./modules/aws/security_group"

  vpc_id              = module.turing_vpc.vpc_id
  aws_resource_prefix = var.aws_resource_prefix
  asg_name            = "PublicLoadBalancerSG"
  asg_description     = "Access to the public facing load balancer"

  asg_rules = {
    "all" = {
      type                     = "ingress"
      description              = "Ingress from the public ALB"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      self                     = null
      source_security_group_id = null
    }
  }

  tags = {
    "environment" = local.environment
  }
}

# Load balancers for getting traffic to containers.
# This sample template creates one load balancer:
#
# - One public load balancer, hosted in public subnets that is accessible
#   to the public, and is intended to route traffic to one or more public
#   facing services.

# A public facing load balancer, this is used for accepting traffic from the public
# internet and directing it to public facing microservices
module "turing_public_elb" {
  source = "./modules/aws/elb/base"

  aws_resource_prefix = var.aws_resource_prefix
  vpc_id              = module.turing_vpc.vpc_id
  security_group_ids  = [module.turing_public_elb_sg.sg_id]
  public_subnets      = module.turing_vpc.vpc_subnet_ids
  idle_timeout        = 30
}

# A dummy target group is used to setup the ALB to just drop traffic
# initially, before any real service target groups have been added.
module "dummy_target_group" {
  source = "./modules/aws/elb/target_group"

  name     = "${var.aws_resource_prefix}-dummy-tg"
  vpc_id   = module.turing_vpc.vpc_id
  port     = 80
  protocol = "HTTP"

  health_checks = {
    http = {
      enabled             = true
      interval            = 6
      path                = "/"
      protocol            = "HTTP"
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }

  lb_listeners = {
    http = {
      lb_arn   = module.turing_public_elb.lb_arn
      protocol = "HTTP"
      port     = 80
      default_action = {
        type = "forward"
      }
    }
  }
}

# A target group. This is used for keeping track of all the tasks, and
# what IP addresses / port numbers they have. You can query it yourself,
# to use the addresses yourself, but most often this target group is just
# connected to an application load balancer, or network load balancer, so
# it can automatically distribute traffic across all the targets.
module "ecs_target_group" {
  source = "./modules/aws/elb/target_group"

  name        = "${var.aws_resource_prefix}-task-definition-tg"
  vpc_id      = module.turing_vpc.vpc_id
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_checks = {
    http = {
      enabled             = true
      interval            = 6
      path                = "/"
      protocol            = "HTTP"
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }
}

# Create a rule on the load balancer for routing traffic to the target group
module "ecs_tg_listener_rule" {
  source = "./modules/aws/elb/listener_rule"

  lb_listener_arn  = module.dummy_target_group.lb_listener_arn[0]
  priority         = 99
  action_type      = "forward"
  target_group_arn = module.ecs_target_group.target_group_arn
  paths            = ["/"]
}


module "turing_ecs" {
  source = "./modules/aws/ecs"

  ecs_depends_on = [module.ecs_tg_listener_rule.lb_listener_rule_created]

  create_ecs_service_role = false

  service_name             = "${var.aws_resource_prefix}-ecs-service"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 80
  deployment_minimum_healthy_percent = 15

  service_subnets          = module.turing_vpc.vpc_subnet_ids
  service_security_groups  = [module.turing_fargate_sg.sg_id]
  service_assign_public_ip = true
  target_group_arn         = module.ecs_target_group.target_group_arn
  container_name           = var.aws_resource_prefix
  container_port           = 8080

  container_definitions = <<-EOF
  [
    {
      "environment": [
          { "name": "NODE_ENV", "value": "${var.environment}" },
          { "name": "MONGO_URI", "value": "${var.mongo_uri}" },
          { "name": "GEOCODER_PROVIDER", "value": "${var.geocoder_provider}" },
          { "name": "GOOGLE_GEOCODING_API_KEY", "value": "${var.geocoder_geocoding_api_key}" },
          { "name": "GEOCODER_LANGUAGE", "value": "${var.geocoder_language}" },
          { "name": "MONGODB_INDEX_LOCALE", "value": "${var.mongo_index_locale}" },
          { "name": "JWT_HASH_KEY", "value": "${var.jwt_hash_key}" },
          { "name": "APP_NAME", "value": "${var.app_name}" },
          { "name": "APP_ID", "value": "${var.app_id}" }
      ],
      "essential": true,
      "image": "${var.image}",
      "name": "${var.service_name}",
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.host_port}
        }
      ]
    }
  ]

  EOF
}
