resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block

  tags = var.tags
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = aws_vpc.my_vpc.cidr_block

  tags = var.tags
}

# Crear internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = var.tags
}

# Sacar la tabla de rutas
data "aws_route_table" "table_id" {
  depends_on = [aws_vpc.my_vpc]

  vpc_id     = aws_vpc.my_vpc.id
}

# Crear ruta en esta tabla
resource "aws_route" "ruta" {
  route_table_id         = data.aws_route_table.table_id.id
  gateway_id             = aws_internet_gateway.gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Crear security group para abrir tráfico
resource "aws_security_group" "allow_traffic" {
  name        = "Nacho"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
      description      = "TLS from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = var.tags
}
