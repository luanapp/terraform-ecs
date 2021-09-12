variable "service_name" {
  description = "ECS service name"
  default     = "DefaultECSServiceName"
}

variable "ecs_depends_on" {
  type        = any
  description = "Any resources that must be finished prior to ECS starting its creation"
  default     = []
}

variable "create_ecs_service_role" {
  type    = bool
  default = false
}

variable "cpu" {
  type        = number
  description = "The number of cpu units used by the task. 1024 is 1 CPU"
  default     = 256
}

variable "memory" {
  type        = number
  description = "How much memory in megabytes to give the container"
  default     = 512
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  type        = set(string)
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
  default     = ["FARGATE"]
}

variable "container_definitions" {
  description = "Json formatted container definition"
  default     = <<-EOT
  EOT
}

variable "desired_count" {
  type        = number
  description = "The number of instances of the task definition to place and keep running"
  default     = 1
}

variable "launch_type" {
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE"
  default     = "FARGATE"
}

variable "deployment_maximum_percent" {
  type        = number
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  default     = 80
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  default     = 15
}

variable "service_subnets" {
  type        = list(string)
  description = "The subnets associated with the task or service."
  default     = []
}

variable "service_security_groups" {
  type        = list(string)
  description = "The security groups associated with the task or service. If you do not specify a security group, the default security group for the VPC is used."
  default     = []
}

variable "service_assign_public_ip" {
  type        = bool
  description = ""
  default     = true
}

variable "target_group_arn" {
  description = "Target group an to be assiciated with the load balancer rules"
}

variable "container_name" {
  description = "Assign a public IP address to the ENI."
}

variable "container_port" {
  type        = number
  description = "The port value, already specified in the task definition, to be used for your service discovery service."
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
