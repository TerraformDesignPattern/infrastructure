module "environment" {
  source = "../"
}

module "bastion" {
  source = "git@github.com:TerraformDesignPattern/bastionhost.git"

  aws_account      = "${module.environment.aws_account}"
  aws_region       = "${module.environment.aws_region}"
  environment_name = "${module.environment.environment_name}"
  hostname         = "${var.hostname}"
  image_id         = "${var.image_id}"
  vpc_name         = "${module.environment.vpc_name}"
}
