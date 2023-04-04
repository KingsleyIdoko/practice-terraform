variable "vpc_cidr_block" {
    type = string
    description = "Entire VPC Subnet"
    default = "10.0.0.0/16"
}
variable "subnet_cidr_blocks" {
    type = list(string)
    description = "Subnets cidr blocks"
    default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "avail_zone" {
    type = list(string)
    description = "Subnet-1 cidr block"
    default = ["eu-west-1a", "eu-west-1b"]
}
variable "env_prefix" {
    type = list(string)
    description = "enviroment description"
    default = ["Dev", "Prod"]
}

