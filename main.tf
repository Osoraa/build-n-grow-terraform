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

# Associate the route table with the subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.bng_public_subnet.id
  route_table_id = aws_route_table.bng_rt.id
}

# Deploy Security Group
resource "aws_security_group" "bng_sg" {
  name = "BNG_SG"
  #   description = "Managed by terraform" default description
  vpc_id = aws_vpc.bng_vpc.id

  tags = {
    Name = "bng_sg"
  }
}

# Allow SSH traffic
# Left open, ssh key-pair would be used
resource "aws_vpc_security_group_ingress_rule" "bng_ssh" {
  security_group_id = aws_security_group.bng_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  tags = {
    Name        = "bng_ssh"
    Description = "Allow all ingress SSH traffic"
  }
}

# Allow HTTP traffic
resource "aws_vpc_security_group_ingress_rule" "bng_http" {
  security_group_id = aws_security_group.bng_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  tags = {
    Name        = "bng_http"
    Description = "Allow all ingress HTTP traffic"
  }
}

# Allow all egress 
resource "aws_vpc_security_group_egress_rule" "bng_allow_all" {
  security_group_id = aws_security_group.bng_sg.id

  cidr_ipv4 = "0.0.0.0/0"
  #   from_port   = 80
  ip_protocol = "-1"
  #   to_port     = 80

  tags = {
    Name        = "bng_allow_all"
    Description = "Allow all Egress traffic"
  }
}

# Deploy a Key Pair
resource "aws_key_pair" "bng_key" {
  key_name   = "bng_key"
  public_key = file("~/.ssh/bng_key.pub")

  tags = {
    Name = "bng_key"
  }
}

# Deploy an instance
resource "aws_instance" "bng_ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.bng_key.id # Equals key_name
  vpc_security_group_ids = [aws_security_group.bng_sg.id]
  subnet_id              = aws_subnet.bng_public_subnet.id

  # User data to run upon instance creation
  user_data = file("./user_data.tpl")

  tags = {
    Name = "bng_ubuntu"
  }
}
