# data "aws_iam_policy_document" "assume_role" {
#  statement {
#    actions = ["sts:AssumeRole"]
#    principals {
#      identifiers = ["lambda.amazonaws.com"]
#      type       = "Service"
#    }
#  }
# }

# resource "aws_iam_role" "lambda_role" {
#   name = "LambdaRole"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "lambda_s3_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
#   role       = aws_iam_role.lambda_role.name
# }

# resource "aws_iam_role_policy_attachment" "lambda_redshift_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
#   role       = aws_iam_role.lambda_role.name
# }

# resource "aws_iam_role_policy_attachment" "logging" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.lambda_role.name
# }

# resource "aws_lambda_function" "csv_redshift_etl_lambda" {
#   function_name = "csv_redshift_etl"
#   package_type  = "Image"
#   image_uri     = "${aws_ecr_repository.my_ecr_repository.repository_url}:${var.lambda_image_tag}"
#   publish       = true
#   role          = aws_iam_role.lambda_role.arn
# }

# resource "aws_lambda_permission" "s3_event_permission" {
#   statement_id  = "AllowExecutionFromS3Event"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.csv_redshift_etl_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.s3_new_csv_upload.arn
# }

# resource "aws_cloudwatch_log_group" "lambda_log_group" {
#   name = "/aws/lambda/${aws_lambda_function.csv_redshift_etl_lambda.function_name}"
# }
