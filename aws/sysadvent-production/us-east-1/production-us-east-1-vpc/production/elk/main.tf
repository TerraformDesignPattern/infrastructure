module "environment" {
  source = "../"
}

module "ami_image_id" {
  source     = "git@github.com:TerraformDesignPattern/packer.git//terraform-ami-module"
  aws_region = "${module.environment.aws_region}"
}

module "elk" {
  source = "git@github.com:TerraformDesignPattern/elk.git//terraform"

  vpc_name         = "${module.environment.vpc_name}"
  aws_region       = "${module.environment.aws_region}"
  aws_account      = "${module.environment.aws_account}"
  environment_name = "${module.environment.environment_name}"
  image_id         = "${module.ami_image_id.docker_image_id}"
  kibana_address   = "prod-elk-use1"
}
