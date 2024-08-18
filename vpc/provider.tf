provider "aws" {
  profile = var.profile
  region = "ap-southeast-1"

  default_tags {
    tags = {
      provisioned_mode = "terraform"
    }
  }
}

  access_key={$AWS_ACCESS_KEY_ID}
  secret_key={$AWS_SECRET_ACCESS_KEY}