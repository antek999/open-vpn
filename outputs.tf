output "ip_addresses_pub" {
  value = aws_instance.ec2-web.*.public_ip
}
