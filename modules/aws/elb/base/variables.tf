variable "aws_resource_prefix" {
  description = "Prefix to be used as part of the name tag"
}

variable "load_balancer_type" {
  description = "ALB type: application/network. It indicates which OSI layer this LB will be created"
  default     = "application"
}

variable "security_group_ids" {
  type        = list
  description = "Array containing security group ids to be associated with this LB"
  default     = []
}

variable "public_subnets" {
  type        = list
  description = "Arrays"
  default     = []
}

variable "idle_timeout" {
  type        = number
  description = "Time in seconds that the connection is allowed to be idle"
  default     = 30
}

variable "vpc_id" {
  description = "VPC id for the LB target group"
}

variable "health_checks" {
  description = "A map containing all health check configurations for the Load Balancer"
  type = map(object({
    enabled             = bool
    interval            = number
    path                = string
    protocol            = string
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  }))
  default = {
    main = {
      enabled             = true
      interval            = 6
      path                = "/"
      protocol            = "HTTP"
      timeout             = 5
      healthy_threshold   = 3
      unhealthy_threshold = 3
    }
  }
}

variable "environment" {
  description = "Terraform Working environment"
  default     = "development"
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
