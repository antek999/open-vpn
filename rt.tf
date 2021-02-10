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


resource "aws_route_table_association" "web" {
  count          = 1
  subnet_id      = aws_subnet.web[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

