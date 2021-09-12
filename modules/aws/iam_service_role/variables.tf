variable "service_name" {
  description = "The AWS service to which this role is attached. You use a string similar to a URL but without the http:// in front. For example: elasticbeanstalk.amazonaws.com"
}

variable "quantity" {
  default = 1
}

variable "role_policy_name" {
  default = ""
}

variable "role_policy_file" {
  description = "The policy content to be attached to the role"
}
