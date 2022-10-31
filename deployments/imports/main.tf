terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.3.3"
}

provider "aws" {
  region = "us-west-1"
  profile = "dsc"
}


