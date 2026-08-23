# AWS Region Configuration
# This variable defines the AWS region where Terraform resources will be created.
# Default region: Mumbai (ap-south-1)

variable "region" {
  description = "value fo region"
  type = string
  default = "ap-south-1"
}
