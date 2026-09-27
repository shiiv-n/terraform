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

locals {
    users_data = yamldecode(file("./user.yaml")).users

    user_role_pair = flatten([ for user in local.users_data: [for role in user.role: { username = user.username, role = role}]])
}

output "output" {
    value = local.user_role_pair
}

# creating users
resource "aws_iam_user" "user" {
    for_each = toset(local.users_data[*].username)
    name = each.value
}

# password for users
resource "aws_iam_user_login_profile" "profile" {
    for_each = aws_iam_user.user
    user = each.value.name
    password_length = 12

  lifecycle {
    ignore_changes = [ 
        password_length,
        password_reset_required,
        pgp_key,
    ]
  }
}

# attaching roles to users
resource "aws_iam_user_policy_attachment" "main" {
    for_each = { 
      for pair in local.user_role_pair :
        "${pair.username}-${pair.role}" => pair
    }

    user = aws_iam_user.user[each.value.username].name
    policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}