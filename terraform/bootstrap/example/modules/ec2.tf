data "aws_ami" "nginx" {
  owners = ["979382823631"]

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.21.2-0-linux-debian-10-x86_64-hvm-ebs-nami*"]
  }
}

resource "aws_instance" "web" {
  count                       = var.instance_count
  ami                         = data.aws_ami.nginx.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_traffic.id]
  tags                        = var.tags
}
