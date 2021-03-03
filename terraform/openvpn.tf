module "openvpn" {
  source            = "./modules/vpn"
  vpc_cidr_block    = var.vpc_cidr_block
  vpc_subnet_blocks = var.vpc_subnet_blocks
  azs               = var.azs
  ami               = var.ami
  instance_type     = "t3.micro"
  home_ips          = var.home_ips
  region            = var.region
  key_pair          = var.key_pair
}

