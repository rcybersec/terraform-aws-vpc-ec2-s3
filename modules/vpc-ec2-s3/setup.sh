#!/bin/bash
# Commands to get awscli and s3fs pre-installed for us so we can mount our S3 bucket
apt update
apt upgrade -y
apt install awscli s3fs -y

# To finish setting up once logged into the instance do the following:
# Retrieve the auth key and secret from the access_keys.txt on the S3 bucket
# Then run echo ACCESS_KEY_ID:SECRET_ACCESS_KEY > /home/ubuntu/.s3fs-creds on the instance
# chmod 600 /home/ubuntu/.s3fs-creds
# mkdir /home/ubuntu/s3_bucket
# And now we mount it with: s3fs push-button-demo-bucket /home/ubuntu/s3_bucket -o passwd_file=/home/ubuntu/.s3fs-creds
# Change the bucket name accordingly to suit your purposes
