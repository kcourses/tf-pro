terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  shared_credentials_files = ["./aws_credentials/credentials"]
  shared_config_files = ["./aws_credentials/config"]
}

provider "aws" {
  region = "eu-central-1"
  alias = "central"
  profile = "central"
  shared_credentials_files = ["./aws_credentials/credentials"]
  shared_config_files = ["./aws_credentials/config"]

  default_tags {
    tags ={
      CustomRole = "true"
    }
  }
#   assume_role {
#     role_arn = "arn:aws:iam::ACC_ID:role/assume-role"
#     session_name = "assumed-role"
#   }
}