terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "5.54.1"
      }
      random = {
        source = "hashicorp/random"
        version = "3.5.1"
      }
    }
}

provider "aws" {
    region = "ap-south-1"
}

resource "random_id" "bucket_id" {
    byte_length = 8
}

resource "aws_s3_bucket" "myappweb_bucket" {
    bucket = "myappweb-${random_id.bucket_id.hex}"
    force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "myappweb_bucket" {
  bucket = aws_s3_bucket.myappweb_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "myappweb" {
  bucket = aws_s3_bucket.myappweb_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"

        Resource = "arn:aws:s3:::${aws_s3_bucket.myappweb_bucket.id}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "myappweb" {
  bucket = aws_s3_bucket.myappweb_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.myappweb_bucket.bucket
  source = "./index.html"
  key    = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.myappweb_bucket.bucket
  source = "./styles.css"
  content_type = "text/css"
  key    = "styles.css"
}

output "name" {
  value = aws_s3_bucket_website_configuration.myappweb.website_endpoint
}