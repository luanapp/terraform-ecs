resource "aws_lb" "this" {
  name               = "${var.aws_resource_prefix}-elb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_group_ids
  subnets            = var.public_subnets
  idle_timeout       = var.idle_timeout

  enable_deletion_protection = var.environment == "production" ? true : false

  tags = merge(
    var.tags,
    var.default_tags
  )
}
