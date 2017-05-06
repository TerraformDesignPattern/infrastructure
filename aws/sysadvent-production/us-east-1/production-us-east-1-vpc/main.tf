module "vpc" {
  source = "git@github.com:TerraformDesignPattern/vpc.git"

  availability_zones = "${var.availability_zones}"
  aws_region         = "${var.aws_region}"
  private_subnets    = "${var.private_subnets}"
  public_subnets     = "${var.public_subnets}"
  vpc_cidr           = "${var.vpc_cidr}"
  vpc_name           = "${var.vpc_name}"
}
