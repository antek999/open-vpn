# VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# Elastic IP

resource "aws_eip" "nat-eip-with-count" {
  vpc   = true
  count = 2
  tags = {
    "Name" = "eip-${count.index}"
  }
}

# Nat Gateway
resource "aws_nat_gateway" "nat-gw" {
  count         = var.create_nat_gw == true ? 2 : 0
  allocation_id = aws_eip.nat-eip-with-count["${count.index}"].id
  subnet_id     = aws_subnet.web[count.index].id

  tags = {
    "Name" = "Nat-Gateway-${count.index}"
  }
}