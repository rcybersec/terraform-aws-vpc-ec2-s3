# Taken right from the official documentation. This ensures we get the latest Ubuntu 20.04 AMI every time we create an instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create our instance based on the information we've filled out so far
resource "aws_instance" "demo_instance" {
  ami                         = data.aws_ami.ubuntu.id 
  instance_type               = "t2.micro" # Free tier elligible
  key_name                    = aws_key_pair.ssh_key_pair.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = aws_subnet.demo_subnet.id
  associate_public_ip_address = true # Gives us a public IP address for the instance so we can SSH to it

  root_block_device {
    volume_size           = 30
    delete_on_termination = true # The root volume will be deleted when you run 'terraform destroy'. Change this to false to prevent that.
  }

# Connect via SSH using the private key we generated, upload setup.sh and then run it on the system to install awscli and s3fs.
# See the comments in setup.sh for how to finish the process and mount the S3 bucket to the instance
# It's possible to auto-mount the S3 bucket with a bit of inventiveness. I'll leave this as an exercise for the reader. 
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("~/.ssh/demo_ssh_key.pub.pem")}"
    host     = self.public_ip
    timeout  = "2m"
    agent    = false
  }

  provisioner "file" {
    source      = "setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh",
    ]
  }

  tags = {
    Name = "push-button-demo-instance"
  }
}
