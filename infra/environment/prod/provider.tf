#------------------------------
# Terraform
#------------------------------
# terraform version
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
# terraform backend
  backend "s3" {
    bucket         = "ansible-remote-2025-prod"
    key            = "prod/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "ansible-remote-locks-dev"
    encrypt        = true
    profile        = "Terraform-resource"
  }
}
# terraform provider
provider "aws" {
  region  = "ap-northeast-1"
  profile = "Terraform-resource"
}