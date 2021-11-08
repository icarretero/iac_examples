provider "aws" {
  # Podría usar proyectos separados para staging y prod
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.64"
    }
  }
}
