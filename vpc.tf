# Create our VPC where all of our resources will live
resource "aws_vpc" "demo_vpc" {
  cidr_block       = "10.0.0.0/24"

  tags = {
    Name = "demo_vpc"
  }
}

# Create a subnet to place our instance in
resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.0.0/24"

  tags = {
    Name = "demo_vpc_subnet"
  }
}

# We need the instance to be publicly accessible thus we setup an internate gateway
resource "aws_internet_gateway" "demo_internet_gateway" {
  vpc_id = aws_vpc.demo_vpc.id
tags = {
    Name = "demo_internet_gateway"
  }
}

# Create a route table so the traffic knows where to go
resource "aws_route_table" "demo_route_table" {
  vpc_id             = aws_vpc.demo_vpc.id
route {
    cidr_block       = "0.0.0.0/0"
    gateway_id       = aws_internet_gateway.demo_internet_gateway.id
  }
tags = {
    Name             = "demo_route_table"
  }
}

# Associate our rate table with our subnet
resource "aws_route_table_association" "demo_subnet_route_association" {
  subnet_id          = aws_subnet.demo_subnet.id
  route_table_id     = aws_route_table.demo_route_table.id
}

# This will pull our public IP address and store it
data "http" "icanhazip" {
   url               = "https://icanhazip.com"
}

# Now we create a security rule that allows inbound SSH from only our IP address
# In the egress section below we're allowing outbound traffic to any public IP. You my want to change this according to your needs
resource "aws_security_group" "allow_ssh" {
  vpc_id             = aws_vpc.demo_vpc.id

  ingress {
    description      = "Inbound SSH access from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [ 
      "${chomp(data.http.icanhazip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name             = "allow_ssh"
  }
 }
