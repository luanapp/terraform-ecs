output "lb_listener_rule_arn" {
  value = aws_lb_listener_rule.this.arn
}

output "lb_listener_rule_created" {
  value      = true
  depends_on = [aws_lb_listener_rule.this.arn]
}
