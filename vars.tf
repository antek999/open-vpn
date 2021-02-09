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
  default     = "ami-0524a6caO61jG1gashYXoPhhlBI5HlbIDKpC4qmRzBtB3o30afb26f308"
  description = "default ami for our instances"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "our default instance type"
}


variable "home_ips" {
  default = []
}

variable "source_packer_ami" {
  default     = "ami-0aef57767f5404a3c"
  description = "source ami for packer"
}

variable "region" {
  default     = "eu-west-1"
  description = "default region"
}

variable "region_for_packer" {
  default     = "eu-west-1"
  description = "region for packer"
}

variable "instance_type_packer" {
  default     = "t3.micro"
  description = "instance type for packer"
}

variable "key_pair" {
  default     = "key_pair"
  description = "our ssh key pair"
}

variable "aws_access_key" {
  type    = string
  default = "aws_acces_key"
}

variable "aws_secret_key" {
  type    = string
  default = "aws_secret_key"
}