#Set the Variables here
variable "aws_profile" {
  description = "Profile name of the AWS Account"
  type = string
}

variable "region" {
  description = "AWS region Eg: us-east-1"
  type = string
   default = "ap-southeast-1"
}

variable "environment_var" {
  description = "environment variable"
  type = string
   default = "dev"
}

variable "profile" {
  description = "Profile name of the AWS Account"
  type = string
  default = "dev"
}
variable "OPEN_ID_ROLE_ARN" {
  description = "open id role"
  type = string
   default = ""
}
