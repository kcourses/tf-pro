data "aws_caller_identity" "default" {}
data "aws_caller_identity" "central" {
  provider = aws.central
}

output "default_caller_identity" {
  value = data.aws_caller_identity.default.account_id
}

output "central_caller_identity" {
  value = data.aws_caller_identity.central.account_id
}