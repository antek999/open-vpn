resource "aws_subnet" "app" {
  count             = 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_subnet_blocks["app-${count.index + 1}"]
  availability_zone = var.azs[count.index % length(var.azs)]
  tags = {
    Name = "app-${count.index}"
    Type = "private"
  }
}

resource "aws_subnet" "web" {
  count                   = 1
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc_subnet_blocks["web-${count.index + 1}"]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index % length(var.azs)]

  tags = {
    Name = "web-${count.index}"
    Type = "public"
  }
}
