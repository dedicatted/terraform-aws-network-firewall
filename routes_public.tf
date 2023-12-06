resource "aws_route_table_association" "public_net" {
  count = length(var.public_net_subnets)

  subnet_id      = element(aws_subnet.public_net[*].id, count.index)
  route_table_id = element(aws_route_table.public_net[*].id, count.index)
}

# send traffic to FW
resource "aws_route" "public_net_fw" {
  count = var.enable_network_firewall ? length(var.public_net_subnets) : 0

  route_table_id         = element(aws_route_table.public_net[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = element(aws_networkfirewall_firewall.this[0].firewall_status[0].sync_states[*].attachment[0].endpoint_id, count.index)

  timeouts {
    create = "5m"
  }

  depends_on = [aws_networkfirewall_firewall.this[0]]
}

# send traffic to IGW
resource "aws_route" "public_net_igw" {
  count = var.enable_network_firewall ? 0 : length(var.public_net_subnets)

  route_table_id         = element(aws_route_table.public_net[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public_fw" {
  count = var.enable_network_firewall ? length(aws_subnet.public_fw) : 0

  subnet_id      = element(aws_subnet.public_fw[*].id, count.index)
  route_table_id = aws_route_table.public_fw[0].id
}

resource "aws_route" "public_fw" {
  count = var.enable_network_firewall ? 1 : 0

  route_table_id         = aws_route_table.public_fw[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}
