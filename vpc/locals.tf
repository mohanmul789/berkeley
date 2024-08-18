locals {
  name   = "${var.PROFILE}_${var.prefix_name}"
  region = "ap-southeast-1"
  tags_all = {
    Environment = var.PROFILE
  }
}