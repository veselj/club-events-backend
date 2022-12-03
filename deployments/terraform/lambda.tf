resource "aws_lambda_function" "club-events-backend" {
  function_name    = "lambda-linux"
  filename         = "../bin/lambda.zip"
  handler          = "lambda-linux"
  source_code_hash = sha256(filebase64("../bin/lambda.zip"))
  role             = aws_iam_role.backend-lambda.arn
  runtime          = "go1.x"
  memory_size      = 128
  timeout          = 1
  publish = true
}

resource "aws_lambda_permission" "lambda-target-permission" {
  statement_id  = "AllowInvokeClubEventsLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.club-events-backend.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.club-events-api.execution_arn}/*/*/*"
}

#resource "aws_lambda_alias" "club-events-backend-dev" {
#  depends_on = [
#    aws_lambda_function.club-events-backend
#  ]
#  name             = "dev"
#  description      = "dev lambda version"
#  function_name    = aws_lambda_function.club-events-backend.handler
#  function_version = aws_lambda_function.club-events-backend.version
##  function_version = "1"
#
#  routing_config {
#    additional_version_weights = {
#      "2" = 0.5
#    }
#  }
#}

resource "aws_iam_role" "backend-lambda" {
  assume_role_policy    = jsonencode(
    {
      Statement = [
        {
          Action    = "sts:AssumeRole"
          Effect    = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        },
      ]
      Version   = "2012-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns   = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  ]
  max_session_duration  = 3600
  name                  = "backend-lambda"
}
