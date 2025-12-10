provider "aws" {
    region = "us-east-1"
}

#Create VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "my-terraform-vpc"
    }
}

#Create Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "my-terraform-igw"
    }
}

#Create public subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "my-terraform-public-subnet"
    }
}

#Create Route Table
resource "aws_route_table" "public" { 
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "my-terraform-public-rt"
    }
}

#Associate Route Table with subnet
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

#Create Security Group
resource "aws_security_group" "web"{
    name = "web-server-sg"
    description = "Security group for web server"
    vpc_id = aws_vpc.main.id


#Allow SSH from yor IP
ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

#Allow HTTP from anywhere
ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

#Allow all outbound traffic
egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name = "web-server-sg"
}
}

#Get the latest Amazon Linux 2 Amazon
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

#Create EC2 Instance
resource "aws_instance" "web" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public.id

    vpc_security_group_ids = [aws_security_group.web.id]

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
                EOF
    tags = {
        Name = "terraform-web-server"
    }

}