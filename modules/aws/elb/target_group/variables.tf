variable "name" {
  description = "Target group name"
}

variable "vpc_id" {
  description = "VPC id to be associated with the target group"
}

variable "port" {
  type        = number
  description = "Target group port"
}

variable "protocol" {
  description = "Target group protocol"
}

variable "target_type" {
  description = "Target type"
  default     = "instance"
}

variable "health_checks" {
  type = map(object({
    enabled             = bool
    interval            = number
    path                = string
    protocol            = string
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  }))
  description = "A map with health checks configurations for the target group"
}

variable "lb_listeners" {
  type = map(object({
    lb_arn   = string
    protocol = string
    port     = number
    default_action = object({
      type = string
    })
  }))
  description = "A map with listeners for a load balancer"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "(Optional) key-value mapping of the resource tags"
  default     = {}
}

variable "default_tags" {
  type        = map(string)
  description = "(Optional) key-value default mapping of the resource tags"
  default = {
    "Created-by" = "Terraform"
  }
}
