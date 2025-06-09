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


// Multi Stage Environment

# dev 

module "dev-app" {
    source = "./modules/ec2"
    my_env = "dev"
    instance_type = "t2.micro"
    ami = "ami-0e9085e60087ce171" 
}

#prd
module "prd-app" {
    source = "./modules/ec2"
    my_env = "prd"
    instance_type = "t2.medium"
    ami = "ami-0e9085e60087ce171" 
}

#stg
module "stg-app" {
    source = "./modules/ec2"
    my_env = "stg"
    instance_type = "t2.small"
    ami = "ami-0e9085e60087ce171" 
  
}
output "dev_app_public_ips" {
  value = module.dev-app.ec2_instances_public_ips
  description = "Public IPs of the dev environment EC2 instances"
}

output "prd_app_public_ips" {
  value = module.prd-app.ec2_instances_public_ips
  description = "Public IPs of the prd environment EC2 instances"
}

output "stg_app_public_ips" {
  value = module.stg-app.ec2_instances_public_ips
  description = "Public IPs of the stg environment EC2 instances"
}