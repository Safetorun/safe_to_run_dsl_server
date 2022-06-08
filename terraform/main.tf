terraform {
  backend "s3" {
    bucket = "kotlin-compiler-terraform-state"
    key    = "tf-state-kompiler"
    region = "eu-west-1"
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