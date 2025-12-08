variable "aws_region" {
    description = "AWS Region"
    type = string
    default = "us-east-1"
}

variable "project_name" {
    description = "Project name for resource naming"
    type = string
    default = "terraform-learning"
}

variable "vpc_cidr" { 
    description = "CIDR block for VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR block for public subnet"
    type = string
    default = "10.0.1.0/24"
}