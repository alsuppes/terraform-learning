# Week 1 Final Project: VPC + EC2 + Security Group

## What This Creates
- VPC with CIDR 10.0.0.0/16
- Public subnet with Internet Gateway
- Security Group allowing SSH and HTTP
- EC2 instance running a simple web server

## How to Use
```bash
terraform init
terraform plan
terraform apply
```

## How to Access
After deployment, get the URL:
```bash
terraform output instance_url
```

## Cleanup
```bash
terraform destroy
```

## What I Learned
[Write 2-3 sentences about what you learned]