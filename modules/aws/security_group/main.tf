resource "aws_security_group" "this" {
  name        = "${var.aws_resource_prefix}-${var.asg_name}"
  description = var.asg_description
  vpc_id      = var.vpc_id

  tags = merge(
    var.default_tags,
    var.tags
  )
}

resource "aws_security_group_rule" "this" {
  for_each = var.asg_rules

  security_group_id = aws_security_group.this.id

  type                     = each.value.type
  description              = "${each.key} - ${each.value.description}"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  self                     = each.value.self
  source_security_group_id = each.value.source_security_group_id
}
