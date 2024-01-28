locals {
  # any ECR repo listed here will be created and open to all Lambdas' image pull
  ecr-repo-names = [
    "example",
  ]
}

module "ecr-repos" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6.0"

  for_each = toset(local.ecr-repo-names)

  repository_name = each.value
  repository_lambda_read_access_arns = ["arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:*"]

  repository_lifecycle_policy = jsonencode({
    rules = [{
      rulePriority = 1
      description = "Expire images older than 1 year"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus = "any"
        countType = "sinceImagePushed"
        countUnit = "days"
        countNumber = 365
      }
    }]
  })

  tags = {
    Env = "dev"
  }
}
