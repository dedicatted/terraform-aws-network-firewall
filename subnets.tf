resource "aws_subnet" "public_net" {
  count = length(var.public_net_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.public_net_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      Name = format("${var.prefix}-pub-net-${var.environment}-%s", element(var.azs, count.index))
    },
    var.default_tags
  )
}

resource "aws_subnet" "public_fw" {
  count = var.enable_network_firewall ? length(var.public_fw_subnets) : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.public_fw_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      Name = format("${var.prefix}-pub-fw-${var.environment}-%s", element(var.azs, count.index))
    },
    var.default_tags
  )
}

resource "aws_subnet" "private_main" {
  count = length(var.private_main_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_main_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      Name = format("${var.prefix}-priv-main-${var.environment}-%s", element(var.azs, count.index))
    },
    var.default_tags
  )
}

resource "aws_subnet" "private_db" {
  count = length(var.private_db_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_db_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      Name = format("${var.prefix}-priv-db-${var.environment}-%s", element(var.azs, count.index))
    },
    var.default_tags
  )
}