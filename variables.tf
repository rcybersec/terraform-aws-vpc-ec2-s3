variable "availability_zone" {
     type    = string
     default = "us-east-1"
}

variable "demo_key_path" {
  default = "~/.ssh/demo_ssh_key.pub.pem"
  sensitive = true
}
