output "aws_account" {
  value = "${basename (path.cwd)}"
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

output "route53_name_servers" {
  value = "${aws_route53_zone.route53_zone.name_servers}"
}

output "route_53_zone_id" {
  value = "${aws_route53_zone.route53_zone.zone_id}"
}

output "ssl_arn" {
  value = "${var.ssl_arn}"
}
