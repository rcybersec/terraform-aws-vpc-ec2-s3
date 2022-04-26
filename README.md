# Terraform Instance-VPC-S3-Bucket Example
This repo is used to show an example of how you might deploy an Ubuntu instance with a simple VPC, an S3 bucket pre-configured with a user and policy in IAM, and the auth key and secret uploaded as an encrypted text file directly to the S3 bucket when the deployment is complete. The idea behind this repo was to provide the user with a usable environment that is a bit more feature complete and secure than the typical barebones deployment of "just getting it to work". I also wanted to whitelist the user's IP address by default in SSH to avoid exposing the instance to the entire internet.

# Deploys the following:

- VPC
- Security Group with SSH for your current public IP as the only allowed ingress access
- Ubuntu t2.micro EC2 instance that will always pull the latest Ubuntu AMI
- S3 bucket with the private ACL setting and a new user created that has read, put and delete permissions (adjust to your needs)
- Versioning is enabled by default on the bucket to protect against accidental file deletion and overwriting. This is meant more for a production environment, so feel free to disable this feature if you don't want it.
- Force delete is disabled so that the S3 bucket won't be deleted if it has files in it
- An auth key and secret are generated and are uploaded to the S3 bucket with AES256 encryption and can be found in the file "access_keys.txt"

# How to use this repo
1. git clone https://github.com/rcsfc/Terraform-Instance-VPC-S3-Bucket-Example.git
2. Run "terraform init"
3. Run "terraform apply" and type "yes" at the prompt

# Destroying the deployment
1. To wipe the slate clean and destroy all of the resources you deployed run the following: "terraform destroy" and type "yes" at the prompt

# ToDo
- Clean up code and introduce more variables
