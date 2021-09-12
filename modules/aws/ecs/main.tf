# This is an IAM role which authorizes ECS to manage resources on your
# account on your behalf, such as updating your load balancer with the
# details of where your containers are, so that traffic can reach your
# containers.
module "ecs_role" {
  source   = "../iam_service_role"
  quantity = var.create_ecs_service_role ? 1 : 0

  service_name     = "ecs.amazonaws.com"
  role_policy_name = "ecs-service"
  role_policy_file = file("${path.module}/templates/ecs-policy.json")
}

# This is a role which is used by the ECS tasks themselves.
module "ecs_task_execution_role" {
  source = "../iam_role"

  role_name               = "ecs_task_execution_role"
  assume_role_policy_file = file("${path.module}/templates/ecs-task-execution-assume-role-policy.json")
  role_path               = "/"

  role_policy_name = "ecs-task-execution-role-policy"
  role_policy_file = file("${path.module}/templates/ecs-task-execution-policy.json")
}

resource "aws_ecs_task_definition" "this" {
  family     = var.service_name
  depends_on = [var.ecs_depends_on]

  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities

  task_role_arn = module.ecs_task_execution_role.role_id

  container_definitions = var.container_definitions

  tags = merge(
    var.tags,
    var.default_tags
  )
}

resource "aws_ecs_cluster" "this" {
  name       = "${var.service_name}-cluster"
  depends_on = [var.ecs_depends_on]
}


resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  iam_role        = module.ecs_role.role_id
  launch_type     = var.launch_type
  depends_on      = [var.ecs_depends_on]


  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.service_subnets
    security_groups  = var.service_security_groups
    assign_public_ip = var.service_assign_public_ip
  }
}
