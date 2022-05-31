locals {
  filename = "../build/distributions/kotlin-compiler-server-1.6.21-SNAPSHOT.zip"
}
resource "aws_s3_bucket" "kotlin_compiler_func_code" {
  bucket = "kotlin-compiler-func-code"
}
data "aws_s3_bucket_object" "aws_lambda_obj" {
  bucket = aws_s3_bucket.kotlin_compiler_func_code.id
  key    = "lambda.zip"
}

resource "aws_lambda_function" "kotlin_compiler_func" {
  function_name    = "kotlin_compiler_func"
  role             = aws_iam_role.kotlin_compiler_iam_role.arn
  handler          = "com.compiler.server.lambdas.StreamLambdaHandler::handleRequest"
  source_code_hash = filebase64sha256(data.aws_s3_bucket_object.aws_lambda_obj.body)
  runtime          = "java11"
  s3_bucket = data.aws_s3_bucket_object.aws_lambda_obj.bucket
  s3_key = data.aws_s3_bucket_object.aws_lambda_obj.key
  s3_object_version = data.aws_s3_bucket_object.aws_lambda_obj.version_id
  timeout = 360
  memory_size = 2048
}

resource "aws_iam_role" "kotlin_compiler_iam_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

