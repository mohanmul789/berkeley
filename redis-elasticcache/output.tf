output "host" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes.0.address
}

output "port" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes.0.port
}