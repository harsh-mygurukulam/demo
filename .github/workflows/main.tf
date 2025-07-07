provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo" {
 bucket = "terraform-drift-demo-bucket-${random_id.suffix.hex}"
  acl    = "private"
}
