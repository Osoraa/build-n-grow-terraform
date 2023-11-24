terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

provider "aws" {
  # shared_config_files      = ["~/.aws/conf"]
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "devn0n-terraform"
}