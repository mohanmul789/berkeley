variable "profile" {
  default = ""
}

variable "prefix_name" {
  description = "The name of the application"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
  default = ""
}

variable "ipv4_public_cidrs" {
  type        = list(any)
  default     = []
  description = "Subnet CIDR blocks (e.g. `10.0.0.0/16`)."
}
variable "ipv4_private_cidrs" {
  type        = list(any)
  default     = []
  description = "Subnet CIDR blocks (e.g. `10.0.0.0/16`)."
}

variable "retention_days" {
  description = "Cloud Watch Log Group retention days"
  type        = number
}

variable "OPEN_ID_ROLE_ARN" {
  description = "open id"
  type        = string
}

