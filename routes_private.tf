resource "aws_route_table_association" "private_main" {
  count = length(var.private_main_subnets)

  subnet_id = element(aws_subnet.private_main[*].id, count.index)
  route_table_id = element(
    aws_route_table.private_main[*].id,
    var.single_nat ? 0 : count.index,
  )
}

resource "aws_route" "private_main_nat" {
  count = var.single_nat ? 1 : local.nat_gateway_count

  route_table_id         = element(aws_route_table.private_main[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private_db" {
  count = length(var.private_db_subnets)

  subnet_id = element(aws_subnet.private_db[*].id, count.index)
  route_table_id = element(
    aws_route_table.private_db[*].id,
    var.single_nat ? 0 : count.index,
  )
}

resource "aws_route" "private_db_nat" {
  count = var.single_nat ? 1 : local.nat_gateway_count

  route_table_id         = element(aws_route_table.private_db[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}