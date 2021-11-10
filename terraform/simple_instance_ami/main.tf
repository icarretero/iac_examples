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

data "aws_ami" "web_site" {
  owners      = ["268229342313"]
  most_recent = true

  filter {
    name   = "name"
    values = ["web_server_*"]
  }
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow-http-inbound-traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.web_site.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_traffic.id]

  tags = var.tags
}
