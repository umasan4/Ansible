#------------------------------
# Terraform
#------------------------------
# terraform version
terraform {
  required_version = "1.13.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # terraform backend
  backend "s3" {
    bucket         = "ansible-remote-2025-dev"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "ansible-remote-locks-dev"
    encrypt        = true
    #profile       = "Terraform-resource"
  }
}
# terraform provider
provider "aws" {
  region = "ap-northeast-1"
  #profile = "Terraform-resource" # github-actions(OIDC)を使うためコメントアウト

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.env
    }
  }
}