# Variables
variable "vpc_cidr_block" {
  default     = "192.168.0.0/24"
  description = "CIDR block for vpc"
}

variable "vpc_subnet_blocks" {
  default     = {}
  type        = map
  description = "CIRD blocks for subnets in vpc"
}

variable "azs" {
  type        = list
  default     = []
  description = "list of availability zones"
}

variable "ami" {
  default     = ""
  description = "default ami for our instances"
}

variable "instance_type" {
  default     = ""
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
  default     = ""
  description = "our ssh key pair"
}

