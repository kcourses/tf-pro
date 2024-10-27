data "aws_region" "current" {}

locals {
  policy_names = ["s3_read_access", "s3_list_access"]
}

resource "aws_iam_policy" "s3_policies" {
  for_each = { for name in local.policy_names : name => name }

  name   = each.key
  path   = "/"
  policy = file("${path.module}/policies/${each.key}.json")
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachments" {
  for_each = aws_iam_policy.s3_policies

  policy_arn = each.value.arn
  role       = aws_iam_role.test_role.name
}

resource "aws_iam_role" "test_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Region = data.aws_region.current.name
  }
}

