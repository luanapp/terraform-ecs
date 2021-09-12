data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_instance_tenancy

  tags = merge(
    { "Name" = "${var.aws_resource_prefix}-vpc" },
    var.default_tags,
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { "Name" = "${var.aws_resource_prefix}-igw" },
    var.default_tags,
    var.tags
  )
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    { "Name" = "${var.aws_resource_prefix}-rtb" },
    var.default_tags,
    var.tags
  )
}

# For the subnets, firstly we check if there are enough availability zones
# given the subnet count. If there are fewer availability zones than the passed subnet count,
# we'll create subnets for the available AZs
# The AZs are randomly chosen using a random_shuffle resource
locals {
  az_length    = length(data.aws_availability_zones.this.names)
  subnet_count = local.az_length >= var.subnet_count ? var.subnet_count : local.az_length
}

resource "random_shuffle" "az_names" {
  input        = data.aws_availability_zones.this.names
  result_count = local.subnet_count
}

resource "aws_subnet" "this" {
  count = local.subnet_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone       = random_shuffle.az_names.result[count.index]
  map_public_ip_on_launch = true


  tags = merge(
    { "Name" = "${var.aws_resource_prefix}-subnet-${count.index + 1}" },
    var.default_tags,
    var.tags
  )
}

resource "aws_route_table_association" "this" {
  count = local.subnet_count

  subnet_id      = element(aws_subnet.this.*.id, count.index)
  route_table_id = aws_default_route_table.this.id
}
