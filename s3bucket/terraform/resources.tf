terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "< 6.0"
    }
  }
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket to create."
}

resource "aws_s3_bucket" "workspace_bucket" {
  bucket = var.bucket_name
}
