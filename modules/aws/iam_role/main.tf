resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = var.assume_role_policy_file
  path               = var.role_path

  tags = merge(
    { Name : var.role_name },
    var.tags,
    var.default_tags
  )
}

resource "aws_iam_role_policy" "this" {
  name = var.role_policy_name
  role = aws_iam_role.this.id

  policy = var.role_policy_file
}
