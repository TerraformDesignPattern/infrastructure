module "cloudtrail" {
  source = "git@github.com:TerraformDesignPattern/cloudtrail.git"

  aws_account = "${basename (path.cwd)}"
  aws_region  = "${var.aws_region}"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.key_pair_name}"
  public_key = "${var.public_key}"
}
