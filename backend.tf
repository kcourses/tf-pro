terraform {
  backend "s3" {
    bucket         = "tf-pro-cert-state-bucket-s9v7iba9fp"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tf-pro-cert-lock-table-s9v7iba9fp"
  }
}
