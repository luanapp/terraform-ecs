output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_subnet_ids" {
  value = aws_subnet.this[*].id
}

output "route_table_id" {
  value = aws_default_route_table.this.id
}
