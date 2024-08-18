module "isolated_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  name = "${local.name}_vpc"
  cidr = var.vpc_cidr

  azs = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = var.ipv4_private_cidrs
  public_subnets  = var.ipv4_public_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true
  manage_default_network_acl = true
  manage_default_security_group = false #checkov:skip=CKV2_AWS_12:This is zeroed out elsewhere
  manage_default_route_table = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  map_public_ip_on_launch = false
  default_network_acl_name = "${local.name}_vpc"

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true #checkov:skip=CKV2_AWS_11:We are enabling it here. Likely false positive
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  flow_log_cloudwatch_log_group_retention_in_days = var.retention_days

  # Define NACL Ingress
  default_network_acl_ingress = [
    { # ICMP
      rule_no    = 81
      action     = "allow"
      from_port  = 0
      to_port    = 0
      icmp_code  = -1
      icmp_type  = -1
      protocol   = "1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 82
      action     = "allow"
      from_port  = 22
      to_port    = 22
      protocol   = "6"
      cidr_block = "0.0.0.0/0"
    },
    { # HTTPS
      rule_no    = 83
      action     = "allow"
      from_port  = 443
      to_port    = 443
      protocol   = "6"
      cidr_block = "0.0.0.0/0"
    },
    { # HTTPS
      rule_no    = 84
      action     = "allow"
      from_port  = 443
      to_port    = 443
      protocol   = "6"
      cidr_block = "100.0.0.0/8"
    },
    { # HTTP
      rule_no    = 85
      action     = "allow"
      from_port  = 80
      to_port    = 80
      protocol   = "6"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 90
      action     = "allow"
      from_port  = 1024
      to_port    = 65535
      protocol   = "6"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    }
  ]
  default_network_acl_egress = [
    { # ICMP
      rule_no    = 81
      action     = "allow"
      from_port  = 0
      to_port    = 0
      icmp_code  = -1
      icmp_type  = -1
      protocol   = "1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 83
      action     = "allow"
      from_port  = 22
      to_port    = 22
      protocol   = "6"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 84
      action     = "allow"
      from_port  = 80
      to_port    = 80
      protocol   = "6"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 85
      action     = "allow"
      from_port  = 443
      to_port    = 443
      protocol   = "6"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 87
      action     = "allow"
      from_port  = 1024
      to_port    = 65535
      protocol   = "6"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 93
      action     = "allow"
      from_port  = 1024
      to_port    = 65535
      protocol   = "17"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 100
      action     = "deny"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    }
  ]

  tags = local.tags_all
}
