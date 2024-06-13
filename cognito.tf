resource "aws_cognito_user_pool" "main" {
  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_subject = "${local.is_antivirus ? "Antivirus" : "Data Classification"} for Amazon S3 - Console Account Information"
      email_message = "A new account has been created for you in the ${local.is_antivirus ? "Antivirus" : "Data Classification"} for Amazon S3 Console.<br/>Your account credentials are provided below:<br/><br/> User Name: {username}<br/> Temporary Password: {####}<br/><br/>This temporary password will expire in 7 days.<br/><br/> Sign in at ${local.console_url} to change your password.<br/><br/>Have Fun,<br/>Cloud Storage Security<br/>support@cloudstoragesec.com<br/>801-410-0408"
      sms_message   = "Your username is {username}. Your temporary password is {####}"
    }
  }

  name              = "${var.service_name}UserPool-${local.application_id}"
  mfa_configuration = "OPTIONAL"
  software_token_mfa_configuration {
    enabled = true
  }

  sms_configuration {
    external_id    = "CloudStorageSecUserPoolExternal-${local.application_id}"
    sns_caller_arn = aws_iam_role.user_pool_sns.arn
    sns_region     = local.aws_region
  }
  auto_verified_attributes = ["email", "phone_number"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  password_policy {
    minimum_length                   = 12
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
  schema {
    attribute_data_type = "Number"
    mutable             = true
    name                = "hide_welcome_msg"
    number_attribute_constraints {
      max_value = 1
      min_value = 0
    }
  }
  schema {
    attribute_data_type = "Number"
    mutable             = true
    name                = "hide_trial_msg"
    number_attribute_constraints {
      max_value = 1
      min_value = 0
    }
  }
  schema {
    attribute_data_type = "Number"
    mutable             = true
    name                = "user_disabled"
    number_attribute_constraints {
      max_value = 1
      min_value = 0
    }
  }
  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "aws_account_id"
    string_attribute_constraints {
      min_length = 12
      max_length = 12
    }
  }

  tags = merge({ (local.application_tag_key) = "ConsoleUserPool" },
    var.custom_resource_tags
  )
}


resource "aws_cognito_user_pool_client" "main" {
  name            = "${var.service_name}UserPoolClient-${local.application_id}"
  user_pool_id    = aws_cognito_user_pool.main.id
  generate_secret = true
}

resource "aws_cognito_user_group" "admins" {
  name         = "Admins"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Accounts with Admin level access and Managed by Terraform"
}

resource "aws_cognito_user_group" "users" {
  name         = "Users"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Accounts with User level access and Managed by Terraform"
}

resource "aws_cognito_user_group" "api" {
  name         = "Api"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Accounts with API level access and Managed by Terraform"
}

resource "aws_cognito_user_group" "primary" {
  name         = "Primary"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Accounts with Primary level access and Managed by Terraform"
}

resource "aws_cognito_user" "admin" {
  user_pool_id             = aws_cognito_user_pool.main.id
  username                 = var.username
  desired_delivery_mediums = ["EMAIL"]
  attributes = {
    email          = "${var.email}"
    email_verified = true
  }
  lifecycle {
    ignore_changes = [
      attributes
    ]
  }
}

resource "aws_cognito_user_in_group" "admin" {
  user_pool_id = aws_cognito_user_pool.main.id
  group_name   = aws_cognito_user_group.admins.name
  username     = aws_cognito_user.admin.username
}
