variable "availability_zone" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "demo_key_path" {
  sensitive = true
}

variable "bucket_prefix" {
  type = string
}
