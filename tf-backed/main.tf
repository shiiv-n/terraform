terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.61.0"
    }
  }
  backend "s3" {
    bucket = "demo-bucket-f22ddc3f751b04dc"
    key = "terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "myserver" {
    ami = "ami-0ac7b260cf76d8865"
    instance_type = "t2.micro"
    tags = {
        Name = "myserver"
    }
}