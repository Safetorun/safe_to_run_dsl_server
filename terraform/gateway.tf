resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/api/logs"
  retention_in_days = 30
}

resource "aws_api_gateway_rest_api" "gw" {
  name = "kotlin_compiler_func_gw"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.gw.id
  resource_id   = aws_api_gateway_resource.gw_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.gw.id
  resource_id   = aws_api_gateway_resource.gw_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.gw.id
  resource_id   = aws_api_gateway_resource.gw_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200_post" {
  rest_api_id = aws_api_gateway_rest_api.gw.id
  resource_id = aws_api_gateway_resource.gw_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"


  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.gw.id
  resource_id = aws_api_gateway_resource.gw_resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"


  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.gw.id
  resource_id = aws_api_gateway_resource.gw_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.gw.id
  resource_id   = aws_api_gateway_resource.gw_resource.id
  http_method   = aws_api_gateway_method.options_method.http_method
  status_code   = aws_api_gateway_method_response.options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}


resource "aws_api_gateway_resource" "gw_resource" {
  rest_api_id = aws_api_gateway_rest_api.gw.id
  parent_id   = aws_api_gateway_rest_api.gw.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.gw.id
  resource_id             = aws_api_gateway_resource.gw_resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.kotlin_compiler_func.invoke_arn
}

resource "aws_api_gateway_deployment" "gw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.gw.id
}

resource "aws_api_gateway_stage" "gw_stage" {
  deployment_id = aws_api_gateway_deployment.gw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.gw.id
  stage_name    = "Prod"
}

# Permission
resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.kotlin_compiler_func.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.gw.execution_arn}/*/*"
}


output "url" {
  value = aws_api_gateway_stage.gw_stage.invoke_url
}