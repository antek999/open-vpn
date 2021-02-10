variable "vpc_cidr_block" {
  default     = "192.168.0.0/24"
  description = "CIDR block for vpc"
}

variable "vpc_subnet_blocks" {
  type        = map
  description = "CIRD blocks for subnets in vpc"
}

variable "azs" {
  type        = list
  default     = ["eu-west-1a", "eu-west-1b"]
  description = "list of availability zones"
}

variable "ami" {
  default     = "ami-0de1f34eb4b27ef7b"
  description = "default ami for our instances"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "our default instance type"
}


variable "home_ips" {
  default = []
}

variable "region" {
  default     = "eu-west-1"
  description = "default region"
}

variable "key_pair" {
  default     = "key_pair"
  description = "our ssh key pair"
}