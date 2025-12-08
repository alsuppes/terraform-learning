# Week 1 Project: VPC with Public Subnet

## What This Creates

This Terraform configuration creates:
- VPC with CIDR block 10.0.0.0/16
- Public subnet in availability zone us-east-1a
- Internet Gateway for public internet access
- Route table with route to Internet Gateway
- Route table association to public subnet

## How to Use
```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# Clean up
terraform destroy
```

## What I Learned

- How to create a VPC with Terraform
- How to set up public subnets
- How to configure internet connectivity
- How to use variables for reusable code
- How to output resource IDs