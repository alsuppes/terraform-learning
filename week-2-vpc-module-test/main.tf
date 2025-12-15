provider "aws" {
    region = "us-east-1"
}

# Use the vpc module
module "dev_vpc" {
    source = "../modules/vpc"

    environment = "dev"
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    availability_zones = ["us-east-1a", "us-east-1b"]

    tags = {
        Project = "Terraform Learning"
        Owner = "Anna Suppes"
    }
}

# Second vpc
module "staging_vpc" {
    source = "../modules/vpc"

    environment = "staging"
    vpc_cidr = "10.1.0.0/16"
    public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

    tags = {
        Project = "Terraform Learning"
        CostCenter = "Engineering"
    }

}