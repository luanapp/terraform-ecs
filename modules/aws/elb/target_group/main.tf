resource "aws_lb_target_group" "this" {
  name        = var.name
  vpc_id      = var.vpc_id
  port        = var.port
  protocol    = var.protocol
  target_type = var.target_type

  dynamic "health_check" {
    for_each = var.health_checks

    content {
      enabled             = health_check.value.enabled
      interval            = health_check.value.interval
      path                = health_check.value.path
      protocol            = health_check.value.protocol
      timeout             = health_check.value.timeout
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
    }
  }

  tags = merge(
    var.tags,
    var.default_tags
  )
}

resource "aws_lb_listener" "this" {
  for_each = var.lb_listeners

  load_balancer_arn = each.value.lb_arn
  protocol          = each.value.protocol
  port              = each.value.port

  default_action {
    type             = each.value.default_action.type
    target_group_arn = aws_lb_target_group.this.arn
  }
}
