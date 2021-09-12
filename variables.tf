variable "aws_account_id" {}
variable "aws_region" {
  description = "AWS region e.g. us-east-1 (Please specify a region supported by the Fargate launch type)"
}

variable "aws_resource_prefix" {
  description = "Prefix to be used in the naming of some of the created AWS resources e.g. demo-webapp"
}

variable "aws_vpc_cidr_block" {
  description = "CIDR for the AWS VPC"
  default     = "115.17.0.0/16"
}

variable "environment" {
  description = "Terraform Working environment"
  default     = "development"
}

variable "mongo_uri" {}

variable "geocoder_provider" {}

variable "geocoder_geocoding_api_key" {}

variable "geocoder_language" {}

variable "mongo_index_locale" {}

variable "jwt_hash_key" {}

variable "app_name" {}

variable "app_id" {}

variable "image" {}

variable "service_name" {}

variable "container_port" {
  type = number
}

variable "host_port" {
  type = number
}
