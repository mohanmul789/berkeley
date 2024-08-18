# #Output from "ecs endpoint" component
# data "terraform_remote_state" "isolated_vpc" {
#   backend   = "s3"
#   workspace = terraform.workspace
#   config = {
#     profile        = var.profile
#     region         = "ap-southeast-1"
#     bucket         = var.state_bucket
#     dynamodb_table = "terraform-state-locks"

#     key = "infra/vpc/terraform.state"
#   }
# }

