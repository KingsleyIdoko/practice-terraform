provider "aws" {
  region     = "eu-west-1"
}
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    "Name" = var.cidr_blocks[0].name
    "env_vpc":"Dev"
  }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id     = aws_vpc.KI_development_vpc.id
  cidr_block =  var.cidr_blocks[1].cidr_block
  availability_zone = "eu-west-1b"
    tags = {
    "Name" =  var.cidr_blocks[0].name
  }
}
data "aws_vpc" "existing-vpc"{
    default = true
}
