resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id
  count  = var.create_nat_gw == true ? 2 : 0
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }
  tags = {
    Name = "private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "web" {
  count          = 2
  subnet_id      = aws_subnet.web[0].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "app" {
  count          = var.create_nat_gw == true ? 2 : 0
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.private-rt[count.index].id
}

