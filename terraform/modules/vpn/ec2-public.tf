resource "aws_instance" "vpn" {
  count                  = 1
  ami                    = var.ami
  instance_type          = var.instance_type
  availability_zone      = var.azs[count.index % length(var.azs)]
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.vpn_and_ssh_SG.id]
  key_name               = var.key_pair
  user_data              = base64encode(templatefile("${path.module}/openvpn_userdata/OpenVPN.sh", {}))


  tags = {
    Name = "vpn-${count.index}"
  }
}