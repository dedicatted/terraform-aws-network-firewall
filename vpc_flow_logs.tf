resource "aws_flow_log" "this" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  log_destination      = aws_s3_bucket.flow_log[0].arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.prefix}-flow-logs-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}

resource "aws_s3_bucket" "flow_log" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  bucket = "${var.prefix}-s3-vpc-flow-logs-${var.environment}-${var.region_name}"

  tags = merge(
    {
      Name = "${var.prefix}-s3-vpc-flow-logs-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}