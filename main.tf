resource "aws_vpc" "bng_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "bng_vpc"
    env  = "dev"
  }
}

resource "aws_subnet" "bng_public_subnet" {
  vpc_id                  = aws_vpc.bng_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "bng_public_subnet"
    env  = "dev"
  }
}
