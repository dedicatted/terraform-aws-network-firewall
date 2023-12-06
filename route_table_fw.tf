resource "aws_route_table" "public_fw" {
  count = var.enable_network_firewall ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.prefix}-rt-pub-fw-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}

resource "aws_route_table" "public_fw_igw" {
  count = var.enable_network_firewall ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.prefix}-rt-pub-igw-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )

}