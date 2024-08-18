variable "region" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "ap-southeast-1"
}

# variable "credentials" {
#   description = "The credentials for connecting to AWS."
#   type = object({
#     access_key = string
#     secret_key = string
#   })
#   sensitive = true
# }

variable "vpc_id" {
  description = "ID of the VPC where the Redis ElastiCache will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the Redis ElastiCache will be deployed."
  type        = list(string)
}

variable "environment" {
  description = "The environment name."
  type        = string
  default = "dev"
}
variable "profile" {
  description = "The profile name."
  type        = string
  default = "dev"
}


variable "app_name" {
  description = "The application name."
  type        = string
  default = "redis-eks"
}

variable "resource_name" {
  description = "The name of the resource."
  type        = string
  default = "redis"
}

variable "state_bucket" {
  description = "The name of the resource."
  type        = string
}
