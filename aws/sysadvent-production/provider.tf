provider "aws" {
  region  = "${var.aws_region}"
  #profile = "{basename (path.cwd)}"
  profile = "sysadvent-production"
}
