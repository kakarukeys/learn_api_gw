locals {
  # any repo listed here can publish to ECR repos thru Github Actions
  github-repos = [
    "kakarukeys/learn_api_gw", 
    "kakarukeys/pru13",
  ]
}

module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "~> 5.33.1"
}

data "aws_iam_policy_document" "ecr-publish-policy-document" {
  # follows https://github.com/aws-actions/amazon-ecr-login#ecr-private

  statement {
    effect = "Allow"
  
    actions = [
      "ecr:GetAuthorizationToken",
      "lambda:GetLayerVersion",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]

    resources = [for r in module.ecr-repos : r.repository_arn]
  }
}

resource "aws_iam_policy" "ecr-publish-policy" {
  name        = "ecr-publish-policy"
  description = "Allow principal to publish images into selected ECR repos"
  policy = data.aws_iam_policy_document.ecr-publish-policy-document.json
}

module "gha-build-role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "~> 5.33.1"

  # specify for Github Enterprise
  # audience     = "https://mygithub.com/<GITHUB_ORG>"
  # provider_url = "mygithub.com/_services/token"

  subjects = [for repo in local.github-repos : "repo:${repo}:ref:refs/heads/main"]

  name = "GHA-Build-Role"
  description = "IAM role for Github Action to assume, for performing tasks related to project build"
  max_session_duration = 3600   # secs

  policies = {
    EcrPublish = aws_iam_policy.ecr-publish-policy.arn
  }
}
