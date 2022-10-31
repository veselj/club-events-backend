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

resource "aws_s3_bucket" "club-events-front-end" {
  bucket = "club-events-front-end"
  tags = {
    Name = "To be distributed by cloud front"
  }
}

resource "aws_s3_bucket_versioning" "club-events-front-end-ver" {
  bucket = "club-events-front-end"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_cognito_user_pool" "members-pool" {

  name = "dsc-members"

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
//    invite_message_template = {}
  }

  alias_attributes = ["email"]
  auto_verified_attributes = ["email"]

  //  device_configuration = ""
//  domain = "dsc-members"
  email_configuration {
    configuration_set = ""
    email_sending_account = "COGNITO_DEFAULT"
    from_email_address = ""
    reply_to_email_address = ""
  }
  email_verification_message = null
  email_verification_subject = null
  mfa_configuration = "OPTIONAL"
  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_numbers = true
    require_symbols = true
    require_uppercase = true
    temporary_password_validity_days = 7
  }

  schema {
    name = "email"
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = true
    required = true
    string_attribute_constraints {
      max_length = 100
      min_length = 5
    }
  }
  schema {
    name = "family_name"
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = true
    required = true
    string_attribute_constraints {
      max_length = 150
      min_length = 1
    }
  }
  schema {
    name = "name"
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = true
    required = true
    string_attribute_constraints {
      max_length = 150
      min_length = 1
    }
  }

  sms_authentication_message = null
  //  sms_configuration {
  //    //      "external_id": "c2f2b233-6065-4d17-bf2a-9f53e00e3915",
  //    //      "sns_caller_arn": "arn:aws:iam::072103297669:role/service-role/SMSRoleForUserPool"
  //  }
  //  sms_verification_message = null
  software_token_mfa_configuration {
    enabled = true
  }
  user_attribute_update_settings {
    attributes_require_verification_before_update = [
      "email"]
  }
  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }
  username_attributes = null
  username_configuration  {
    case_sensitive = true
  }
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message = "This is a confirmation message {####}"
//    email_message_by_link = "link"
    email_subject = "Confirmation subject"
    email_subject_by_link = "by link"
    sms_message = "Code: {####}"
  }
}

resource "aws_cognito_user_group" "sailors" {
  name         = "sailors"
  user_pool_id = aws_cognito_user_pool.members-pool.id
  description  = "sailors"
  precedence   = 1
//  role_arn     = aws_iam_role.group_role.arn
}