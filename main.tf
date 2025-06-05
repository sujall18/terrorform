terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "sujal-haha-demo-terraform-state-s3-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "sujal-haha-terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = "10.0.0.0/16"
  availability_zones    = ["us-west-2a"]
  private_subnet_cidrs  = ["10.0.1.0/24"]
  public_subnet_cidrs   = ["10.0.2.0/24"]
  name                  = "sujal-demo-vpc"
}
