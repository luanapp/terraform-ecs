variable "role_name" {
  default = ""
}

variable "assume_role_policy_file" {
  type        = string
  description = "A json file containing a aws assume role policy"
}

variable "role_path" {
  description = "The path for the role"
  default     = "/"
}

variable "role_policy_name" {
  default = ""
}

variable "role_policy_file" {
  description = "The policy content to be attached to the role"
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
