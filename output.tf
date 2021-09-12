output "vpc_id" {
  value = module.turing_vpc.vpc_id
}

output "vpc_subnet_ids" {
  value = module.turing_vpc.vpc_subnet_ids
}

output "vpc_route_table_id" {
  value = module.turing_vpc.route_table_id
}

output "turing_fargate_sg_id" {
  value = module.turing_fargate_sg.sg_id
}

output "turing_fargate_sg_name" {
  value = module.turing_fargate_sg.sg_name
}

output "turing_public_elb_sg_id" {
  value = module.turing_public_elb_sg.sg_id
}

output "turing_public_elb_sg_name" {
  value = module.turing_public_elb_sg.sg_name
}

output "turing_public_elb_arn" {
  value = module.turing_public_elb.lb_arn
}

output "turing_public_elb_dns_name" {
  value = module.turing_public_elb.lb_dns_name
}

output "turing_ecs_id" {
  value = module.turing_ecs.id
}

output "turing_ecs_name" {
  value = module.turing_ecs.name
}

output "turing_ecs_cluster" {
  value = module.turing_ecs.cluster
}

output "turing_ecs_desired_count" {
  value = module.turing_ecs.desired_count
}
