resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.prefix}-igw-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}