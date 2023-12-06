resource "aws_route_table" "public_net" {
  count = length(var.public_net_subnets)

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = format("${var.prefix}-rt-pub-net-${var.environment}-%s", element(var.azs, count.index))
    },
    var.default_tags
  )
}