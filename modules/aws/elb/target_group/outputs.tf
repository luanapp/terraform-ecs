output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "lb_listener_arn" {
  value = [for lb_listener in aws_lb_listener.this : lb_listener.arn]
}