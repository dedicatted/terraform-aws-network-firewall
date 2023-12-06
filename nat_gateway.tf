resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = element(
    aws_eip.nat[*].id,
    var.single_nat ? 0 : count.index,
  )
  subnet_id = element(aws_subnet.public_net[*].id, count.index)

  tags = merge(
    {
      Name = format("${var.prefix}-nat-${var.environment}-%s", element(var.azs, var.single_nat ? 0 : count.index))
    },
    var.default_tags
  )

  depends_on = [aws_internet_gateway.this, aws_eip.nat[0]]
}

resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  tags = merge(
    {
      Name = format("${var.prefix}-nat-ip-${var.environment}-%s", element(var.azs, var.single_nat ? 0 : count.index))
    },
    var.default_tags
  )

  depends_on = [aws_internet_gateway.this]
}