# Create our private and public SSH keys we'll be using to connect to the instance
resource "tls_private_key" "demo_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "demo_ssh_key"
  public_key = tls_private_key.demo_ssh_key.public_key_openssh

# Export the private key to a local file in our ~/.ssh/ directory and chmod it to 600 to avoid permissions errors
provisioner "local-exec" {    # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.demo_ssh_key.private_key_pem}' > ${var.demo_key_path}
      chmod 600 ${var.demo_key_path}
    EOT
  }
}
