# VPC Module

## Description
Creates a VPC with public subnets, Internet Gateway, and routing.

## Usage
```hcl
module "vpc" {
  source = "./modules/vpc"

  environment          = "dev"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_cidr | CIDR block for VPC | string | "10.0.0.0/16" | no |
| environment | Environment name | string | n/a | yes |
| public_subnet_cidrs | CIDR blocks for public subnets | list(string) | ["10.0.1.0/24", "10.0.2.0/24"] | no |
| availability_zones | AZs for subnets | list(string) | ["us-east-1a", "us-east-1b"] | no |

## Outputs
| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| public_subnet_ids | IDs of public subnets |
| internet_gateway_id | ID of the Internet Gateway |

## What This Creates
- 1 VPC
- 2+ Public Subnets
- 1 Internet Gateway
- 1 Public Route Table
- Route table associations

## Example: Multiple Environments
```hcl
module "dev_vpc" {
  source      = "./modules/vpc"
  environment = "dev"
  vpc_cidr    = "10.0.0.0/16"
}

module "prod_vpc" {
  source      = "./modules/vpc"
  environment = "prod"
  vpc_cidr    = "10.1.0.0/16"
}
```