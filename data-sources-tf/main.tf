terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.64.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
}

data "aws_ami" "name" {
    most_recent = true
    owners = ["amazon"]
}

output "aws_ami" {
    value = data.aws_ami.name.id
}

resource "aws_instance" "myserver" {
    ami = data.aws_ami.name.id
    instance_type = "t2.micro"
    tags = {
        Name = "myserver"
    }
}

# to get the account details
data "aws_caller_identity" "name" {
}
output "caller_info" {
    value = data.aws_caller_identity.name
}