# Sets our availability zone
variable "availability_zone" {
  type = string
  default = "us-east-1"
}

# Sets our default instance type. Increase this as you see fit
variable "instance_type" {
  type = string
  default = "t2.micro"
}

# Path to the SSH key we generate during the deployment
variable "demo_key_path" {
  default = "~/.ssh/demo_ssh_key.pub.pem" 
  sensitive = true
}

# The general naming convention of our bucket will be "push-button-demo-somerandomstring". Change this to suit your needs
variable "bucket_prefix" {
  type = string
  default = "push-button-demo-"
}
