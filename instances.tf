# This ensures we get the latest Ubuntu 20.04 AMI every time we create an instance
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
  user_data                   = "${file("setup.sh")}" # Uses cloud-init to more reliably install our packages

  root_block_device {
    volume_size           = 30
    delete_on_termination = true # The root volume will be deleted when you run 'terraform destroy'. Change this to false to prevent that.
}

  tags = {
    Name = "push-button-demo-instance"
  }
}
