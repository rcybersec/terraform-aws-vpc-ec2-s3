provider "aws" {
    region = "us-east-1"
}

module "vpc-ec2-s3" {
  source="./modules/vpc-ec2-s3"
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  demo_key_path = var.demo_key_path
  bucket_prefix = var.bucket_prefix
}
