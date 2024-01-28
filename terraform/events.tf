# resource "aws_cloudwatch_event_rule" "s3_new_csv_upload" {
#  name       = "s3-new-csv-upload"
#  description = "Triggers when a new csv file is uploaded to S3"

#  event_pattern = <<PATTERN
# {
#   "source": ["aws.s3"],
#   "detail-type": ["Object Created"],
#   "detail": {
#     "bucket": {
#       "name": ["learn-lambda-my-bucket"]
#     },
#     "object": {
#       "key": [{
#         "prefix": "taxi"
#       }]
#     }
#   }
# }
# PATTERN
# }

# resource "aws_cloudwatch_event_target" "s3_new_csv_upload" {
#  rule     = aws_cloudwatch_event_rule.s3_new_csv_upload.name
#  target_id = "lambda_function"
#  arn      = aws_lambda_function.csv_redshift_etl_lambda.arn
# }
