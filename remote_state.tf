data "terraform_remote_state" "s3" {
  backend = "s3"

  config = {
    bucket = "tf-pro-cert-state-bucket-s9v7iba9fp"
    key    = "dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

output "remote_state_iam_role_arn" {
  value = data.terraform_remote_state.s3.outputs.iam_role_arn
}

data "aws_s3_object" "state" {
  bucket = "tf-pro-cert-state-bucket-s9v7iba9fp"
  key    = "dev/terraform.tfstate"
}

output "s3_object_state_iam_role_arn" {
  value = jsondecode(data.aws_s3_object.state.body).outputs.iam_role_arn.value
}