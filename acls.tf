data "aws_subnets" "filtered" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  dynamic "filter" {
    for_each = var.subnet_tags
    content {
      name   = "tag:${filter.key}"
      values = [filter.value]
    }
  }
}

# output "subnets" {
#   value = data.aws_subnets.filtered.ids
# }

resource "aws_network_acl" "main" {
  vpc_id     = var.vpc_id
  subnet_ids = data.aws_subnets.filtered.ids

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "main"
  }
}