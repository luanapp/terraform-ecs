terraform {
  required_version = "~> 0.12"

  backend "s3" {
    bucket  = "todxs-terraform"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region  = var.aws_region
  version = "~> 2.7"
}

provider "random" {
  version = "~> 2.2"
}
