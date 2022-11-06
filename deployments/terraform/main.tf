terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.3.3"

  backend "s3" {
    bucket = "janman.cc-club-events-backend"
    key = "state-dev"
    region = "eu-west-1"
    dynamodb_table = "club-events-backend-lock-table-dev"
    encrypt = true
    profile = "dsc"
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}


