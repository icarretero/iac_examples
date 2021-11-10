resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.1.0/24"

  tags = var.tags
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = aws_vpc.my_vpc.cidr_block

  tags = var.tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = var.tags
}

data "aws_route_table" "route_table" {
  depends_on = [aws_vpc.my_vpc]

  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "add_external_route" {
  route_table_id         = data.aws_route_table.route_table.id
  gateway_id             = aws_internet_gateway.gw.id
  destination_cidr_block = "0.0.0.0/0"
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow-http-and-ssh-inbound-traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  # Ejemplo para usar dynamic aunque yo haría grupos separados
  dynamic "ingress" {
    for_each = { http = 80, ssh = 22 }
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = var.tags
}

data "template_file" "user_data" {
  template = file("../../cloud-init/ssh_user.yml")
  # template = file("../../cloud-init/complete.yml")
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_traffic.id]
  user_data                   = data.template_file.user_data.rendered

  tags = var.tags
}
