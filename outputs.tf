# The bucket name is generated using bucket_prefix so there will be a random string appended to it to prevent users from creating the same bucket. This will output the name of that.
output "bucket" {
   value = module.vpc-ec2-s3.bucket
}

# Output the SSH command for the user so they can copy and paste to get to their instance
output "ssh_command" {
   value = module.vpc-ec2-s3.ssh_command
}
