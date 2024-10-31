run "validate_acls_vpc_id" {
  command = plan

  assert {
    condition = aws_network_acl.main.vpc_id == var.vpc_id
    error_message = "VPC ID is not matching"
  }
}

run "validate_network_acl_on_ingress" {
  command = plan

  assert {
    condition = length(aws_network_acl.main.ingress) > 0
    error_message = "Network ACLs have no ingress rules"
  }
}