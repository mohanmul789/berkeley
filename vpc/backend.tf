# terraform workspace select default
# terraform init -backend-config=$ENV-backend.tfvars -reconfigure
# terraform workspace select $ENV

terraform {
 backend "s3" {
 }
}

