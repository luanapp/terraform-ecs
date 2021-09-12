output "sg_id" {
  value = aws_security_group.this.id
}

output "sg_name" {
  value = aws_security_group.this.name
}

output "sg_rule_id" {
  value = [for sg_rule in aws_security_group_rule.this : sg_rule.id]
}

output "sg_rule_description" {
  value = [for sg_rule in aws_security_group_rule.this : sg_rule.description]
}

output "sg_rule_type" {
  value = [for sg_rule in aws_security_group_rule.this : sg_rule.type]
}

output "sg_rule_protocol" {
  value = [for sg_rule in aws_security_group_rule.this : sg_rule.protocol]
}
