terraform {
  backend "s3" {
    bucket = "terraform-devops-dev"
    key = "packer_infra.tfstate"
  }
}
