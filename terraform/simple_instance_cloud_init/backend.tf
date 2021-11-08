terraform {
  backend "s3" {
    bucket = "terraform-devops-dev"
    key = "simple_instance_cloud_init.tfstate"
  }
}
