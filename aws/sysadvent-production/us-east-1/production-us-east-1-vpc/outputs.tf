output "availability_zones" {
  value = "${var.availability_zones}"
}

output "flow_log_cloudwatch_log_group_arn" {
  value = "${module.vpc.flow_log_cloudwatch_log_group_arn}"
}

output "flow_log_cloudwatch_log_stream_arn" {
  value = "${module.vpc.flow_log_cloudwatch_log_stream_arn}"
}

output "internet_gateway_id" {
  value = "${module.vpc.internet_gateway_id}"
}

output "nat_eips" {
  value = ["${module.vpc.nat_eips}"]
}

output "private_route_table_ids" {
  value = ["${module.vpc.private_route_table_ids}"]
}

output "private_subnet_cidr_blocks" {
  value = ["${module.vpc.private_subnet_cidr_blocks}"]
}

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnet_ids}"]
}

output "public_route_table_ids" {
  value = ["${module.vpc.public_route_table_ids}"]
}

output "public_subnet_cidr_blocks" {
  value = ["${module.vpc.public_subnet_cidr_blocks}"]
}

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnet_ids}"]
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
