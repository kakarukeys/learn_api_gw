output "region" {
  description = "AWS region"
  value       = var.region
}

output "repository_url" {
  description = "ECR repo urls"
  value       = [for r in module.ecr-repos : r.repository_url]
}
