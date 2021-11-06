output "web_instance_ip" {
  value = aws_instance.web[0].public_ip
}
