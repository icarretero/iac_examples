provider "aws" {
  region = "us-east-1"
}

variable "env_name" {
  default = "nacho"
}

# data "aws_vpc" "vpc" {
#   id = var.vpc_id
# }

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.env_name
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = var.env_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.env_name
  }
}

data "aws_route_table" "route_table" {
  # subnet_id = aws_subnet.main.id
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "add_external_route" {
  route_table_id         = data.aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

data "aws_ami" "nginx" {
  most_recent = true
  owners      = ["979382823631"]

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.21.3-0-linux-debian*"]
  }
}

resource "aws_security_group" "access_from_outside" {
  name        = "access_from_outside"
  description = "Access EC2 from outside"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.nginx.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.access_from_outside.id]

  tags = {
    Name = var.env_name
  }
}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}
