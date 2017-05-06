variable "availability_zones" {
  default = ["us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "aws_region" {
  default = "us-east-1"
}

variable "private_subnets" {
  default = [
    "172.19.101.0/24",
    "172.19.102.0/24",
    "172.19.103.0/24",
  ]
}

variable "public_subnets" {
  default = [
    "172.19.1.0/24",
    "172.19.2.0/24",
    "172.19.3.0/24",
  ]
}

variable "vpc_cidr" {
  default = "172.19.0.0/16"
}

variable "vpc_name" {
  default = "production-us-east-1-vpc"
}
