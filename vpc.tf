resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "${var.prefix}-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}
