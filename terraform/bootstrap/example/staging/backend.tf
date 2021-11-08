terraform {
  backend "s3" {
    bucket = "terraform-devops-dev"
    key = "staging.tfstate"
    dynamodb_table = "nacho-tf-lock-staging"
  }
}
