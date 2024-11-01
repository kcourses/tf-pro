module "asg" {
  source = "./modules/autoscaling"

  name = "tf-pro-cert"
  subnets = data.aws_subnets.filtered.ids

  providers = {
    aws = aws
    aws.central = aws.central
  }
}

output "asg_id" {
  value = module.asg.asg_id
}

# module "asg2" {
#   source = "./modules/autoscaling"
#
#   name = "tf-pro-cert2"
# }