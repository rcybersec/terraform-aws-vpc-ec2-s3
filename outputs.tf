output "ssh_command" {
  value = ["Run this command to connect: ssh -i ~/.ssh/demo_ssh_key.pub.pem ubuntu@${aws_instance.demo_instance.public_ip}"]
}
