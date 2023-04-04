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
  cidr_block =  var.subnet_cidr_blocks[0]
  availability_zone = var.avail_zone[0]
    tags = {
    "Name" =  "${var.env_prefix[0]}-subnet-1"
  }
}
resource "aws_subnet" "myapp-subnet-2" {
  vpc_id     = aws_vpc.myapp_vpc.id
  cidr_block =  var.subnet_cidr_blocks[1]
  availability_zone = var.avail_zone[1]
    tags = {
    "Name" =  "${var.env_prefix[0]}-subnet-2"
  }
}
resource "aws_internet_gateway" "myapp-gw" {
  vpc_id = aws_vpc.myapp_vpc.id
tags = {
    Name = "${var.env_prefix[0]}-myapp-igw"
  }
}
resource "aws_route_table" "dev-rtb" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-gw.id
  }
tags = {
    Name = "${var.env_prefix[0]}-myapp-rtb"
  }
}

resource "aws_route_table_association" "myapp-route-subnet-1-association" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.dev-rtb.id
}
resource "aws_route_table_association" "myapp-route-subnet-2-association" {
  subnet_id      = aws_subnet.myapp-subnet-2.id
  route_table_id = aws_route_table.dev-rtb.id
}