resource "aws_s3_bucket" "infra_bucket"{
  bucket = "terraform-devops-dev"
  acl = "private"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "infra_locktable" {
  name = "tf_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
      name = "LockID"
      type = "S"
  }
  tags = {
      Name = "TF Lock"
  }
}

# resource "aws_ecr_repository" "infra_repo" {
#   name = "nacho/infra"
#
#   image_tag_mutability = "MUTABLE"
#
#   tags = {
#       Name="Infra Repo"
#   }
# }
