provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket  = "microservice-tf-state"
    key     = "eks/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.61"
    }
  }
}