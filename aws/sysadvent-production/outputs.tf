output "aws_account" {
  value = "${var.aws_account}"
}

output "cloudtrail_cloudwatch_log_group_arn" {
  value = "${module.cloudtrail.cloudtrail_cloudwatch_log_group_arn}"
}

output "domain_name" {
  value = "${var.domain_name}"
}

output "key_pair_name" {
  value = "${var.key_pair_name}"
}

output "primary_zone_id" {
  value = "${aws_route53_zone.primary_zone.id}"
}

output "ssl_arn" {
  value = "${var.ssl_arn}"
}
