#VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

tags = merge(
    {
        Name = "${var.environment}-vpc"
        Environment = var.environment
    },
    var.tags
)
}

#Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        {
            Name = "${var.environment}-igw"
            Environment = var.environment
        },
        var.tags
    )
}

#Public subnets
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = merge(
    {
        Name = "${var.environment}-public-subnet-${count.index + 1}"
        Environment = var.environment
        Type = "Public"
    },
    var.tags

    )
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name        = "${var.environment}-private-subnet-${count.index + 1}"
      Environment = var.environment
      Type        = "Private"
    },
    var.tags
  )
}

#Public Route Table
resource "aws_route_table" "public" {
    vpc_id =  aws_vpc.main.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = merge(
        {
            Name = "${var.environment}-public-rt"
            Environment = var.environment
        },
        var.tags
    )
}

# Route Table Associations
resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
    
}

#Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
    count = var.enable_nat_gateway && length(var.private_subnet_cidrs) > 0 ? (var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs)) : 0
    domain = "vpc"

    tags = merge(
        {
            Name = "${var.environment}-nat-eip${count.index + 1}"
            Environment = var.environment
        },
        var.tags
    )

    depends_on = [aws_internet_gateway.main]
}

#NAT Gateways
resource "aws_nat_gateway" "main" {
    count         = var.enable_nat_gateway && length(var.private_subnet_cidrs) > 0 ? (var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs)) : 0
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public[count.index].id

    tags = merge(
        {
            Name = "${var.environment}-nat-${count.index + 1}"
            Environment = var.environment
        },
        var.tags
    )

    depends_on = [aws_internet_gateway.main]
}

# Private route Tables
resource "aws_route_table" "private" {
    count  = length(var.private_subnet_cidrs) > 0 ? (var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs)) : 0
    vpc_id = aws_vpc.main.id

    tags = merge (
        {
            Name = "${var.environment}-private-rt-${count.index + 1}"
            Environment = var.environment
        },
        var.tags
    )
}

#Routes to NAT Gateway for private subnets
resource "aws_route" "private_nat_gateway" {
    count = var.enable_nat_gateway && length(var.private_subnet_cidrs) > 0 ? (var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs)) : 0
    route_table_id = aws_route_table.private[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
}

#Private Route Table Associations
resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}