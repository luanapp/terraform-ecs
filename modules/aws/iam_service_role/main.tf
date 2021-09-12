resource "aws_iam_service_linked_role" "this" {
  count            = var.quantity
  aws_service_name = var.service_name
}

resource "aws_iam_role_policy" "this" {
  count = var.quantity
  name  = var.role_policy_name
  role  = aws_iam_service_linked_role.this[count.index].id

  policy = var.role_policy_file
}
