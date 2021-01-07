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
  default     = ["ap-northeast-2a", "ap-northeast-2b"]
  description = "list of availability zones"
}

variable "ami" {
  default     = "ami-0094965d55b3bb1ff"
  description = "default ami for our instances"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "our default instance type"
}


variable "home_ips" {
  default = []
}
