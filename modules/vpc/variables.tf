variable "vpc_cidr" {
    description = "CIDR block for VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "environment" {
    description = "Environment name (dev, staging, prod)"
    type = string
}

variable "public_subnet_cidrs" {
    description = "CIDR blocks for public subnets"
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
    description = "Availability zones for subnets"
    type = list(string)
    default = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway"{
    description = "Enable NAT Gateway for private subnets"
    type = bool
    default = false
}

variable "tags" {
    description = "Additional tags for resources"
    type = map(string)
    default =  {}
}