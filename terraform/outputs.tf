output "region" {
  description = "AWS region"
  value       = var.region
}

output "repository_url" {
  description = "ECR repo urls"
  value       = [for r in module.ecr-repos : r.repository_url]
}

output "gha_build_role_arn" {
  description = "arn of GHA Build Role"
  value       = module.gha-build-role.arn
}
