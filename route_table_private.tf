resource "aws_route_table" "private_main" {
  count = local.nat_gateway_count

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = var.single_nat ? "${var.prefix}-rt-priv-main-${var.environment}-${var.region_name}" : format("${var.prefix}-rt-priv-main-${var.environment}-%s", element(var.azs, count.index))
    },
    var.default_tags
  )
}

resource "aws_route_table" "private_db" {
  count = local.nat_gateway_count

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = var.single_nat ? "${var.prefix}-rt-priv-db-${var.environment}-${var.region_name}" : format("${var.prefix}-rt-priv-db-${var.environment}-%s", element(var.azs, count.index))
    },
    var.default_tags
  )
}