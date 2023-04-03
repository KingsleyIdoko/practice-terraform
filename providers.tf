terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    ciscoasa = {
      source = "CiscoDevNet/ciscoasa"
      version = "1.3.0"
    }
  }
}