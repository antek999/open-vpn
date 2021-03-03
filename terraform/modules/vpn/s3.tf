resource "aws_s3_bucket" "openvpn" {
  bucket = "my-s3-bucket-for-openvpn"
  acl    = "private"
  lifecycle_rule {
    enabled = true
    id      = "expire_all_files"

    expiration {
      days = 1
    }
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
