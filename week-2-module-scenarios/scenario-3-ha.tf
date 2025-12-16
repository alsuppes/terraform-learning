# Scenario 3: High availability VPC with NAT in each AZ
module "ha_vpc" {
    source = "../modules/vpc"

    environment = "prod-ha"
    vpc_cidr = "10.30.0.0/16"
    public_subnet_cidrs = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]
    private_subnet_cidrs = ["10.30.10.0/24", "10.30.11.0/24", "10.30.12.0/24"]
    availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

    enable_nat_gateway = true
    single_nat_gateway = false 

    tags = {
        Scenario = "High Availability Production"
    }
}

output "ha_vpc_id" {
    value = module.ha_vpc.vpc_id
}

output "ha_nat_gateways" {
    value = module.ha_vpc.nat_gateway_ids
}