resource "aws_cognito_user_pool" "members-pool" {

  name = "dsc-members"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  # Forces to use a user name
  // alias_attributes = ["email"]

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  //  device_configuration = ""
  //  domain = "dsc-members"
  email_configuration {
    configuration_set      = ""
    email_sending_account  = "COGNITO_DEFAULT"
    from_email_address     = ""
    reply_to_email_address = ""
  }
  email_verification_message = null
  email_verification_subject = null
  mfa_configuration          = "OPTIONAL"
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  schema {
    name                     = "name"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 150
      min_length = 1
    }
  }

  schema {
    name                     = "family_name"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 150
      min_length = 1
    }
  }

  schema {
    name                     = "email"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 100
      min_length = 5
    }
  }

  /** Custom Attributes */
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "friend1"
    required                 = false
    string_attribute_constraints {
      min_length = 1
      max_length = 40
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "friend2"
    required                 = false
    string_attribute_constraints {
      min_length = 1
      max_length = 40
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "friend3"
    required                 = false
    string_attribute_constraints {
      min_length = 1
      max_length = 40
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "friend4"
    required                 = false
    string_attribute_constraints {
      min_length = 1
      max_length = 40
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "friend5"
    required                 = false
    string_attribute_constraints {
      min_length = 1
      max_length = 40
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "friend6"
    required                 = false
    string_attribute_constraints {
      min_length = 1
      max_length = 40
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "friend7"
    required                 = false
    string_attribute_constraints {
      min_length = 1
      max_length = 40
    }
  }

  sms_authentication_message = null

  software_token_mfa_configuration {
    enabled = true
  }
  user_attribute_update_settings {
    attributes_require_verification_before_update = [
      "email"
    ]
  }
  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }
  username_configuration {
    case_sensitive = false
  }
  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
    email_message         = "This is a confirmation message {####}"
    email_subject         = "Confirmation subject"
    email_subject_by_link = "by link"
    sms_message           = "Code: {####}"
  }
}

resource "aws_cognito_user_group" "sailors" {
  name         = "sailors"
  user_pool_id = aws_cognito_user_pool.members-pool.id
  description  = "sailors"
  precedence   = 10
}

resource "aws_cognito_user_group" "rowers" {
  name         = "rowers"
  user_pool_id = aws_cognito_user_pool.members-pool.id
  description  = "rowers"
  precedence   = 20
}

resource "aws_cognito_user_group" "safety-helms" {
  name         = "safety-helms"
  user_pool_id = aws_cognito_user_pool.members-pool.id
  description  = "safety-helms"
  precedence   = 30
}

resource "aws_cognito_user_group" "power-boat-drivers" {
  name         = "power-boat"
  user_pool_id = aws_cognito_user_pool.members-pool.id
  description  = "power-boat"
  precedence   = 40
}

resource "aws_cognito_user_group" "animators" {
  name         = "animators"
  user_pool_id = aws_cognito_user_pool.members-pool.id
  description  = "animators"
  precedence   = 50
}

resource "aws_cognito_user_group" "admins" {
  name         = "admins"
  user_pool_id = aws_cognito_user_pool.members-pool.id
  description  = "admins"
  precedence   = 60
}

resource "aws_cognito_user_pool_client" "members-pool_client" {
  name                  = "dsc-members-pool-client"
  user_pool_id          = aws_cognito_user_pool.members-pool.id
  access_token_validity = 24
  token_validity_units {
    access_token = "hours"
  }
  generate_secret                      = false
  callback_urls                        = ["https://dsc-events.janman.cc/dashboard"]
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows = [ "USER_PASSWORD_AUTH" ]
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
  logout_urls                          = ["https://dsc-events.janman.cc/logout"]

    read_attributes = [ "name", "family_name", "email", "custom:friend1", "custom:friend2", "custom:friend3", "custom:friend4", "custom:friend5", "custom:friend6", "custom:friend7"]
    write_attributes = [ "name", "family_name", "email", "custom:friend1", "custom:friend2", "custom:friend3", "custom:friend4", "custom:friend5", "custom:friend6", "custom:friend7"]

#  read_attributes  = ["name", "family_name", "email", "custom:friend1"]
#  write_attributes = ["name", "family_name", "email", "custom:friend1"]
}

resource "aws_cognito_user_pool_domain" "dsc-members" {
  domain       = "dsc-members-domain"
  user_pool_id = aws_cognito_user_pool.members-pool.id
}

resource "aws_cognito_user" "jan" {
  user_pool_id = aws_cognito_user_pool.members-pool.id
  username     = "ian.vesely@gmail.com"

  attributes = {
    email          = "ian.vesely@gmail.com"
    family_name    = "Vesely"
    name     = "Jan"
    email_verified = true
  }
}