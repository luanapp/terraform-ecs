variable "aws_resource_prefix" {
  description = "Prefix to be used as part of the name tag"
}

variable "vpc_id" {
  description = "To create the ASG we need the VPC id this SG will be attached to"
}

variable "asg_name" {
  description = "Friendly name for the ASG"
}

variable "asg_description" {
  description = "Description text for the ASG"
}

variable "asg_rules" {
  type = map(object({
    type                     = string
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    self                     = bool
    source_security_group_id = string
  }))
  description = "An object with all sg rules"
  default = {
    "default" = {
      type                     = "ingress"
      description              = "Default ingress rule allowing ingress inside the ASG"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      cidr_blocks              = null
      self                     = true
      source_security_group_id = null
    }
  }
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
