provider "aws" {
  region = var.region
}

# terraform plan -var-file=envs/dev.tfvars -out plan.out
