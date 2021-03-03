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

# Route Table
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

resource "aws_route_table_association" "public" {
  count          = 1
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

# Subnets
resource "aws_subnet" "public" {
  count                   = 1
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc_subnet_blocks["public-${count.index + 1}"]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index % length(var.azs)]

  tags = {
    Name = "public-${count.index}"
    Type = "public"
  }
}

# Security Group
resource "aws_security_group" "vpn_and_ssh_SG" {
  name        = "allow-ssh-and-vpn"
  description = "Allow ssh and vpn connection"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = concat([aws_vpc.main.cidr_block], var.home_ips)
  }

  ingress {
    description = "vpn"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = concat([aws_vpc.main.cidr_block], var.home_ips)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh and vpn security group"
  }
}

#Null Resource
resource "null_resource" "presigned-url" {
  depends_on = [aws_s3_bucket.openvpn]

  provisioner "local-exec" {

    command = "aws s3 presign --region ${var.region} s3://my-s3-bucket-for-openvpn/client1.ovpn"
  }
}

