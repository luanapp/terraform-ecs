output "id" {
  value = aws_ecs_service.this.id
}

output "name" {
  value = aws_ecs_service.this.name
}

output "cluster" {
  value = aws_ecs_service.this.cluster
}

output "iam_role" {
  value = aws_ecs_service.this.iam_role
}

output "desired_count" {
  value = aws_ecs_service.this.desired_count
}
