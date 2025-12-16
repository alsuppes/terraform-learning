#Scenario 2: Full VPC with public and private subnets + NAT
module "full_vpc" {
    source = "../modules/vpc"

    environment = "staging-full"
    vpc_cidr = "10.20.0.0/16"
    public_subnet_cidrs = ["10.20.1.0/24", "10.20.2.0/24"]
    private_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]
    availability_zones = ["us-east-1a", "us-east-1b"]

    enable_nat_gateway = true
    single_nat_gateway = true
    
    tags = {
        Scenario = "Full VPC with Private Subnets"
    }
}

output "full_vpc_id" {
    value = module.full_vpc.vpc_id
}

output "full_public_subnets" {
    value = module.full_vpc.public_subnet_ids
}

output "full_private_subnets" {
    value = module.full_vpc.private_subnet_ids
}

output "full_nat_gateways" {
    value = module.full_vpc.nat_gateway_ids
}