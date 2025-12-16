provider "aws" {
    region = "us-east-1"
}

#Scenario 1: Simple VPC with only public subnets
module "simple_vpc" {
  source = "../modules/vpc"

  environment          = "dev-simple"
  vpc_cidr            = "10.10.0.0/16"
  public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
  
  # No private subnets, no NAT gateway needed

    tags = {
        Scenario = "Simple Public Only"
    }
}

output "simple_vpc_id" {
    value = module.simple_vpc.vpc_id
}

output "simple_public_subnets" {
    value = module.simple_vpc.public_subnet_ids
}