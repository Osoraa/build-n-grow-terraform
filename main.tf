# Deploy a Virtual Private Cloud(VPC)
resource "aws_vpc" "bng_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "bng_vpc"
    env  = "dev"
  }
}

# Deploy a subnet in the VPC
resource "aws_subnet" "bng_public_subnet" {
  vpc_id                  = aws_vpc.bng_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "bng_public_subnet"
    env  = "dev"
  }
}

# Deploy an Internet Gateway in the VPC
resource "aws_internet_gateway" "bng_igw" {
  vpc_id = aws_vpc.bng_vpc.id

  tags = {
    Name = "bng_igw"
    env  = "dev"
  }
}

# Deploy a route table
resource "aws_route_table" "bng_rt" {
  vpc_id = aws_vpc.bng_vpc.id

  # Remove managed routes
  # route = []

  tags = {
    Name = "bng_rt"
    env  = "dev"
  }
}

# Route to be associated with the route table
resource "aws_route" "bng_route" {
  route_table_id         = aws_route_table.bng_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bng_igw.id
  depends_on             = [aws_route_table.bng_rt]
}

