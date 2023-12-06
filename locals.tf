locals {
  max_priv_subnet_length = max(
    length(var.private_db_subnets),
    length(var.private_main_subnets)
  )
  nat_gateway_count = var.single_nat ? 1 : local.max_priv_subnet_length

  managed_stateful_rule_groups = toset(
    [
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/AbusedLegitBotNetCommandAndControlDomainsActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/AbusedLegitMalwareDomainsActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/BotNetCommandAndControlDomainsActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/MalwareDomainsActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWebActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesDoSActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesEmergingEventsActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesExploitsActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesFUPActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesIOCActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareCoinminingActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareMobileActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareWebActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesPhishingActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesScannersActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesSuspectActionOrder",
        "arn:aws:network-firewall:${var.region}:aws-managed:stateful-rulegroup/ThreatSignaturesWebAttacksActionOrder"
      ]
  )

}