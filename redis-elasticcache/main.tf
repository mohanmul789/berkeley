
locals {
  env_id = substr(var.environment, 0, min(15, length(var.environment)))
  app_id = substr(var.app_name, 0, min(15, length(var.app_name)))
  res_id = substr(var.resource_name, 0, min(15, length(var.resource_name)))
  #res_id = substr(split(".", var.resource_name)[3], 0, min(15, length(var.resource_name)))
  cluster_id = replace(lower("${local.env_id}-${local.app_id}-${local.res_id}"), "_", "-")
}

resource "aws_security_group" "redis_security_group" {
  #vpc_id = data.terraform_remote_state.isolated_vpc.outputs.vpc_id
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = local.cluster_id
  subnet_ids = var.subnet_ids
  #subnet_ids = data.terraform_remote_state.isolated_vpc.outputs.private_subnets
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = local.cluster_id
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_security_group.id]
}

