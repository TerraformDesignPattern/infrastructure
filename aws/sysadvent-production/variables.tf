variable "aws_account" {
  default = "sysadvent-production"
}

variable "aws_account_id" {
  default = ""
}

variable "aws_region" {
  default = "us-east-1"
}

variable "domain_name" {
  default = "sysadvent.host"
}

variable "key_pair_name" {
  default = "sysadvent-key"
}

variable "ssl_arn" {
  default = ""
}

variable "public_key" {
  default = ""
}
