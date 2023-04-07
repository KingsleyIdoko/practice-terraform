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
# resource "aws_route_table" "dev-rtb" {
#   vpc_id = aws_vpc.myapp_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-gw.id
#   }
# tags = {
#     Name = "${var.env_prefix[0]}-myapp-rtb"
#   }
# }

# resource "aws_route_table_association" "myapp-route-subnet-1-association" {
#   subnet_id      = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.dev-rtb.id
# }
# resource "aws_route_table_association" "myapp-route-subnet-2-association" {
#   subnet_id      = aws_subnet.myapp-subnet-2.id
#   route_table_id = aws_route_table.dev-rtb.id
# }


resource "aws_default_route_table" "myapp-default-rtb" {
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-gw.id
  }
tags = {
    Name = "${var.env_prefix[0]}-myapp-default-rtb"
  }
}

resource "aws_default_security_group" "myapp-vpc-sg" {
  vpc_id      = aws_vpc.myapp_vpc.id

  ingress {
    description      = "http traffic to the vpc"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["31.21.206.50/32"]
  }
 ingress {
    description      = "http traffic to the vpc"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "ssh traffic to the vpc"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix[0]}-myapp-sg"
  }
}


data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "myapp-ec2" {
  ami       = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.my-app-instance-type[0]
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.myapp-vpc-sg.id]
  availability_zone = var.avail_zone[0]
  associate_public_ip_address = true
  key_name = "my ssh-key-pair"

  user_data = file("post-deployement-config.sh")

tags = {
    Name = "${var.env_prefix[0]}-myapp-ec2-instance"
  }

}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image
}
