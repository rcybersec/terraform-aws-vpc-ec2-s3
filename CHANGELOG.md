## 1.0.0 (Month Day, Year)

FEATURES:

* Create a VPC with a security group that has your public IP whitelisted by default
* Create a EC2 instance running the latest Ubuntu AMI
* Create an S3 bucket with a policy and a new IAM user that has the policy attached
* Upload the auth key and secret as an encrypted text file to the S3 bucket
* Use cloud-init to install S3FS and AWSCli
