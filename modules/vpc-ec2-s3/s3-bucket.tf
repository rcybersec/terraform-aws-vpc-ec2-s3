# The user to which we will grant access to s3
resource "aws_iam_user" "demo_user" {
  name          = "demo-s3-user"
  path          = "/"
}

# Create an IAM role that we'll assign later on
resource "aws_iam_role" "demo-user-role" {
 name = "demo-user-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# This is the policy we're attaching to the user we're creating that will allow us to access the S3 bucket and mount it via s3fs to the instance
resource "aws_iam_policy" "demo-user-policy" {
 name = "demo-user-policy"

 policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    { "Effect": "Allow",
      "Action": [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets" 
     ],
      "Resource": "arn:aws:s3:::*" 
},
    { "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::var.bucket_name"]
},
    { "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::var.bucket_name/*"]
    }
  ]
}
EOF
}

# Attach our policy to our role with the correct ARN
resource "aws_iam_role_policy_attachment" "demo-user-policy-attach" {
  role = "${aws_iam_role.demo-user-role.name}"
  policy_arn = "${aws_iam_policy.demo-user-policy.arn}"
}

# Attach our policy to our user with the correct ARN
resource "aws_iam_user_policy_attachment" "demo-user-attach" {
  user = aws_iam_user.demo_user.name
  policy_arn = "${aws_iam_policy.demo-user-policy.arn}"
}

# Create the access key
resource "aws_iam_access_key" "demo_key" {
  user = aws_iam_user.demo_user.name
}

# Create the bucket for storing our files
resource "aws_s3_bucket" "push-button-bucket" {
  bucket_prefix = var.bucket_prefix
  force_destroy = false # Prevents the bucket from being deleted if there are files in it and you run 'terraform destroy'. Change to true to bypass this
}

# Creates an ACL that restricts our bucket to private
resource "aws_s3_bucket_acl" "demo_bucket_acl" {
  bucket = aws_s3_bucket.push-button-bucket.id
  acl    = "private"
}

# Enables versioning on the bucket. This is fairly essential in a production environment as it allows files to be recovered if they're overwritten or deleted
resource "aws_s3_bucket_versioning" "demo_bucket_versioning" {
  bucket = aws_s3_bucket.push-button-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create the object inside the token bucket. This is uploaded with AES256 encryption. Better than printing in plain text to the console or to a file on the local disk
resource "aws_s3_object" "demo_token_file" {
  bucket                 = aws_s3_bucket.push-button-bucket.id
  key                    = "access_keys.txt"
  server_side_encryption = "AES256"
  content_type = "text/plain"
  content = <<EOF
access_id: ${aws_iam_access_key.demo_key.id}
access_secret: ${aws_iam_access_key.demo_key.secret}
EOF
}
