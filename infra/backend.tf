#aws configuration 
terraform {
  backend "s3" {
    bucket = "backend-website001"
    key = "terraform/state/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}


