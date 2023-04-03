provider "aws" {
  region     = "eu-west-1"
}
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix[0]}-vpc"
  }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id     = aws_vpc.myapp_vpc.id
  cidr_block =  var.subnet_cidr_block
  availability_zone = var.avail_zone[0]
    tags = {
    "Name" =  "${var.env_prefix[0]}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-gw" {
  vpc_id = aws_vpc.myapp_vpc.id
tags = {
    Name = "${var.env_prefix}-myapp-igw"
  }
}
resource "aws_route_table" "dev-rtb" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-gw
  }
tags = {
    Name = "${var.env_prefix}-myapp-rtb"
  }
}

