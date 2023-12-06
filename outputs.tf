output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "private_main_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_main[*].id
}

output "private_db_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_db[*].id
}

output "public_net_subnets" {
  value = aws_subnet.public_net[*].id
}

output "app_lb_sg_id" {
  value = aws_security_group.application_lb.id
}

output "app_ec2_sg_id" {
  value = aws_security_group.application_ec2.id
}
