output "ip_addresses_pub" {
  value = aws_instance.vpn.*.public_ip
}
