terraform {

  cloud {
    organization = "safetorun"
    workspaces {
      name = "safe-to-run-compiler-server"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}