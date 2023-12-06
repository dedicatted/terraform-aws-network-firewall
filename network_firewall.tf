resource "aws_networkfirewall_rule_group" "stateless" {
  count = var.enable_network_firewall ? 1 : 0

  capacity = 50
  name     = "${var.prefix}-stateless-rg-${var.environment}-${var.region_name}"
  type     = "STATELESS"
  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
            priority = 10
            rule_definition {
              actions = ["aws:forward_to_sfe"]
              match_attributes {
                source {
                  address_definition = "0.0.0.0/0"
                }
                destination {
                  address_definition = "0.0.0.0/0"
                }
              }
            }
        }
      }
    }
  }

  tags = merge(
    {
      Name = "${var.prefix}-stateless-rg-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}

resource "aws_networkfirewall_rule_group" "stateful" {
  count = var.enable_network_firewall ? 1 : 0

  capacity = 50
  name     = "${var.prefix}-stateful-rg-${var.environment}-${var.region_name}"
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "public_subnets"
        ip_set {
          definition = var.public_net_subnets
        }
      }

      port_sets {
        key = "https_http"
        port_set {
          definition = ["443", "80"]
        }
      }
    }

    stateful_rule_options {
      rule_order = "DEFAULT_ACTION_ORDER"
    }

    rules_source {
      dynamic stateful_rule {
        for_each = toset(var.network_firewall_stateful_rules)
        content {
          action = stateful_rule.value.action
          header {
            destination = stateful_rule.value.header.destination
            destination_port = stateful_rule.value.header.destination_port
            direction = stateful_rule.value.header.direction
            protocol = stateful_rule.value.header.protocol
            source = stateful_rule.value.header.source
            source_port = stateful_rule.value.header.source_port
          }
          rule_option {
            keyword   = stateful_rule.value.rule_option.keyword
            settings  = stateful_rule.value.rule_option.settings
          }
        }
      }
    }
  }

  tags = merge(
    {
      Name = "${var.prefix}-stateful-rg-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}

resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.enable_network_firewall ? 1 : 0

  name = "${var.prefix}-fw-policy-${var.environment}-${var.region_name}"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:pass"]
    stateless_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.stateless[0].arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.stateful[0].arn
    }

    dynamic stateful_rule_group_reference {
      for_each = local.managed_stateful_rule_groups
      content {
        resource_arn = stateful_rule_group_reference.key
      }
    }
  }

  tags = merge(
    {
      Name = "${var.prefix}-fw-policy-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}

resource "aws_networkfirewall_firewall" "this" {
  count = var.enable_network_firewall ? 1 : 0

  name                = "${var.prefix}-firewall-${var.environment}-${var.region_name}"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this[0].arn
  vpc_id              = aws_vpc.this.id
  dynamic subnet_mapping {
    for_each = aws_subnet.public_fw
    content {
      subnet_id         = subnet_mapping.value.id
      ip_address_type = "IPV4"
    }
  }

  tags = merge(
    {
      Name = "${var.prefix}-firewall-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}

resource "aws_s3_bucket" "fw_log" {
  count = var.enable_vpc_flow_logs && var.enable_network_firewall? 1 : 0

  bucket = "${var.prefix}-s3-fw-logs-${var.environment}-${var.region_name}"

  tags = merge(
    {
      Name = "${var.prefix}-s3-fw-logs-${var.environment}-${var.region_name}"
    },
    var.default_tags
  )
}

resource "aws_networkfirewall_logging_configuration" "example" {
  count = var.enable_network_firewall_logs && var.enable_network_firewall ? 1 : 0

  firewall_arn = aws_networkfirewall_firewall.this[0].arn

  logging_configuration {
    log_destination_config {
      log_destination = {
        bucketName = aws_s3_bucket.fw_log[0].bucket
        prefix     = "/FWLogs"
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  }
}