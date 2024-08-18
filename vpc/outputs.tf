output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.isolated_vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.isolated_vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.isolated_vpc.vpc_cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.isolated_vpc.default_security_group_id
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = module.isolated_vpc.vpc_owner_id
}

output "private_subnets" {
  description = "ID of private subnets"
  value       = module.isolated_vpc.private_subnets
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.isolated_vpc.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.isolated_vpc.private_subnets_cidr_blocks
}

# output "isolated_subnet_a" {
#   description = "ID of isolated_subnet_a subnet"
#   value       = resource.aws_subnet.isolated_subnet_a.id
# }
#
# output "isolated_subnet_b" {
#   description = "ID of isolated_subnet_b subnet"
#   value       = resource.aws_subnet.isolated_subnet_b.id
# }
#
# output "isolated_subnet_c" {
#   description = "ID of isolated_subnet_c subnet"
#   value       = resource.aws_subnet.isolated_subnet_c.id
# }
