resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags       = merge(var.tags, { Name = var.env})
}

# This subnet block need to nbe improvement in code dry concept
resource "aws_subnet" "main" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  tags              = merge(var.tags, { Name = "public_subnet"})
  availability_zone = var.azs[count.index]
}

resource "aws_subnet" "web" {
  count             = length(var.web_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnets[count.index]
  tags              = merge(var.tags, { Name = "web_subnet"})
  availability_zone = var.azs[count.index]
}

resource "aws_subnet" "app" {
  count             = length(var.app_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnets[count.index]
  tags              = merge(var.tags, { Name = "app_subnet"})
  availability_zone = var.azs[count.index]
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnets[count.index]
  tags              = merge(var.tags, { Name = "db_subnet"})
  availability_zone = var.azs[count.index]
}