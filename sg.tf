locals {
  sg_tables = { for name, sg in jsondecode(file("./security_groups_data/sg.json")).security_groups : sg["name"] => sg }
  #  sg_table_rules = { for idx, rule in csvdecode(file("./security_groups_data/sg_rules.csv")) : idx => rule if rule["rule_type"] == "ingress" && rule["dst_cidr"] != "" }
  sg_table_rules = { for idx, rule in csvdecode(file("./security_groups_data/sg_rules.csv")) : idx => rule }
}

### Not working - issue with cycle
# resource "aws_security_group" "sg" {
#   for_each = local.sg_tables
#
#   name = each.key
#   description = each.value.description
#
#   dynamic "ingress" {
#     for_each = { for idx, rule in local.sg_table_rules: idx => rule if rule["sg_name"] == each.key }
#
#     content {
#       from_port = tonumber(split("-", ingress.value.port_range)[0])
#       to_port = tonumber(split("-", ingress.value.port_range)[1])
#       protocol = ingress.value.protocol
#       cidr_blocks = ingress.value.dst_cidr != "" ? [ingress.value.dst_cidr] : null
# #       security_groups = ingress.value.dst_sg != "" ? [aws_security_group.sg[ingress.value.dst_sg].id] : mull
#     }
#   }
# }

### Correct
resource "aws_security_group" "sg" {
  for_each = local.sg_tables

  name        = each.key
  description = each.value.description
}

resource "aws_security_group_rule" "sg_rules" {
  for_each = local.sg_table_rules

  security_group_id = aws_security_group.sg[each.value.sg_name].id

  type      = each.value.rule_type
  protocol  = each.value.protocol
  from_port = tonumber(split("-", each.value.port_range)[0])
  to_port   = tonumber(split("-", each.value.port_range)[1])

  cidr_blocks              = each.value.dst_cidr != "" ? [each.value.dst_cidr] : null
  source_security_group_id = each.value.dst_sg != "" ? aws_security_group.sg[each.value.dst_sg].id : null

  depends_on = [aws_security_group.sg]
}