module "iam" {
  source = "./modules/iam"
  iam_role_name = "s3_access_role"
}

# moved {
#   from = aws_iam_role.test_role
#   to   = module.iam.aws_iam_role.test_role
# }

output "iam_role_arn" {
  value = module.iam.iam_role_arn
}

output "iam_role_id" {
  value = module.iam.iam_role_id
}

output "iam_policies_arn" {
  value = module.iam.iam_policies_arn
}