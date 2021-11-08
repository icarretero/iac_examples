terraform {
  backend "s3" {
    # Este podría ser otro bucket para no mezclar nada
    # bucket = "terraform-devops-staging"
    bucket = "terraform-devops-dev"
    key = "simple_instance_module_staging.tfstate"
  }
}
