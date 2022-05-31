terraform {
  required_version = "1.1.7"

  cloud {
    organization = "safetorun"
    workspaces {
      name = "safe-to-run-compiler-server"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}