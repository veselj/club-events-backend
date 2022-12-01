data "template_file" "club-events-openapi" {
  template = file("../../api/club-events.api.yaml")
  //vars = var.api_template_vars
}

resource "aws_apigatewayv2_api" "club-events-api" {
  name                       = "club-events-api"
  protocol_type              = "HTTP"
  cors_configuration {
    allow_methods = ["GET", "PUT", "OPTIONS", "POST"]
    allow_origins = [ "*"]
  }
  route_selection_expression = "$request.method $request.path"
  body = data.template_file.club-events-openapi.rendered
}

resource "aws_apigatewayv2_authorizer" "club-events-api-auth" {
  api_id           = aws_apigatewayv2_api.club-events-api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-user-pool-authorizer"

  jwt_configuration {
    audience = ["sailors","rowers"]
    issuer   = "https://${aws_cognito_user_pool.members-pool.endpoint}"
  }
}

resource "aws_apigatewayv2_stage" "club-events-api-dev" {
  api_id = aws_apigatewayv2_api.club-events-api.id
  name   = "dev"
}

#resource "aws_apigatewayv2_deployment" "club-events-api-dev-deployment" {
#  api_id      = aws_apigatewayv2_api.club-events-api.id
#  description = "Dev deployment"
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}
