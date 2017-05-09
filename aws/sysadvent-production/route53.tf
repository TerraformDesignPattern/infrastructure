resource "aws_route53_zone" "route43_zone" {
  name = "${var.domain_name}"

  tags {
    DomainName = "${var.domain_name}"
  }
}
