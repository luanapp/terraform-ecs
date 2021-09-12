variable "aws_resource_prefix" {
  description = "Prefix to be used as part of the name tag"
}

variable "vpc_cidr_block" {
  description = "VPC's cidr block"
}

variable "vpc_instance_tenancy" {
  description = "(Optional) VPC's instance tenancy"
  default     = "default"
}

variable "vpc_enable_dns_hostnames" {
  default = false
}

variable "subnet_count" {
  type        = number
  description = "Contains the number of subnets to be created on the VPC"
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
