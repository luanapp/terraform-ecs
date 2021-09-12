output "role_id" {
  value = length(aws_iam_service_linked_role.this) > 0 ? aws_iam_service_linked_role.this[0].id : ""
}
