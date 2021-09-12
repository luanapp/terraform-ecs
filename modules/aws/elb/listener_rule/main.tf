resource "aws_lb_listener_rule" "this" {
  listener_arn = var.lb_listener_arn
  priority     = var.priority

  action {
    type             = var.action_type
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = var.paths
    }
  }
}
