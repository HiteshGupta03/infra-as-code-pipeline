
terraform {
  backend "s3" {
    bucket         = "infra-as-code-pipeline-tfstate-597692077614"
    key            = "infra-as-code-pipeline/main/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
    dynamodb_table = "infra-as-code-pipeline-tf-locks"
  }
}
