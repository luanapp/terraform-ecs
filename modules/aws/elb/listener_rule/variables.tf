variable "lb_listener_arn" {
  description = "Load Balancer listener ARN"
}

variable "priority" {
  type        = number
  description = "Load Balancer listener rule priority"
}

variable "action_type" {
  description = "Listener rule action type"
  default     = "forward"
}

variable "target_group_arn" {
  description = "Load Balancer target group arn"
}

variable "paths" {
  type        = list(string)
  description = "Path pattern for the rule starting with the leading / "
}
