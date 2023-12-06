# To IGW
resource "aws_route_table_association" "public_fw_to_igw" {
  count = var.enable_network_firewall ? length(var.public_net_subnets) : 0

  subnet_id      = element(aws_subnet.public_fw[*].id, count.index)
  route_table_id = aws_route_table.public_fw[0].id
}

resource "aws_route" "public_fw_to_igw" {
  count = var.enable_network_firewall ? 1 : 0

  route_table_id         = aws_route_table.public_fw[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

# From IGW
resource "aws_route" "public_fw_from_igw" {
  count = var.enable_network_firewall ? length(var.public_net_subnets) : 0

  route_table_id         = aws_route_table.public_fw_igw[0].id
  destination_cidr_block = element(var.public_net_subnets, count.index)
  vpc_endpoint_id        = element(aws_networkfirewall_firewall.this[0].firewall_status[0].sync_states[*].attachment[0].endpoint_id, count.index)

  depends_on = [aws_networkfirewall_firewall.this[0]]
}

resource "aws_route_table_association" "public_fw_from_igw" {
  count = var.enable_network_firewall ? 1 : 0

  gateway_id      = aws_internet_gateway.this.id
  route_table_id  = aws_route_table.public_fw_igw[0].id
}