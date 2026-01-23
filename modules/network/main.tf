resource "aws_vpc" "vpc" {
  cidr_block                = var.vpc_cidr

  enable_dns_support        = true
  enable_dns_hostnames      = true

  tags = {
    Name                    = "krikey-vpc-${var.environment}"
    Environment             = var.environment
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id                    = aws_vpc.vpc.id

  tags = {
    Name                    = "krikey-igw-${var.environment}"
    Environment             = var.environment
  }
}

resource "aws_subnet" "default" {
  count                     = length(var.availability_zones)
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone         = element(var.availability_zones, count.index)

  tags = {
    Name                    = "krikey-${var.environment} - ${element(var.availability_zones, count.index)}"
    Environment             = var.environment
  }
}

resource "aws_subnet" "krikey_rds" {
  vpc_id                    = aws_vpc.vpc.id
  count                     = length(var.rds_availability_zones)
  cidr_block                = cidrsubnet(var.rds_subnet_cidr, 1, count.index)
  availability_zone         = element(var.rds_availability_zones, count.index)

  tags = {
    Name                    = "krikey-rds-${var.environment} - ${element(var.rds_availability_zones, count.index)}"
    Environment             = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                    = aws_vpc.vpc.id
  count                     = length(var.public_subnets_cidr)
  cidr_block                = element(var.public_subnets_cidr, count.index)
  availability_zone         = element(var.availability_zones, count.index)

  map_public_ip_on_launch   = true

  tags = {
    Name                    = "krikey-${var.environment} - ${element(var.availability_zones, count.index)}-public-subnet"
    Environment             = var.environment
  }
}

resource "aws_subnet" "private" {
  vpc_id                    = aws_vpc.vpc.id
  count                     = length(var.private_subnets_cidr)
  cidr_block                = element(var.private_subnets_cidr, count.index)
  availability_zone         = element(var.availability_zones, count.index)
  map_public_ip_on_launch   = false

  tags = {
    Name                    = "krikey-${var.environment} - ${element(var.availability_zones, count.index)}-private-subnet"
    Environment             = var.environment
  }
}

resource "aws_default_route_table" "public" {
  default_route_table_id    = aws_vpc.vpc.main_route_table_id

  tags = {
    Name                    = "krikey-${var.environment}-public-route-table"
    Environment             = var.environment
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id            = aws_default_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.ig.id

  timeouts {
    create                  = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count                     = length(var.public_subnets_cidr)
  subnet_id                 = element(aws_subnet.public.*.id, count.index)
  route_table_id            = aws_default_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id                    = aws_vpc.vpc.id

  tags = {
    Name                    = "krikey-${var.environment}-route-table-private"
  }
}

resource "aws_route_table_association" "private" {
  count                     = length(var.private_subnets_cidr)
  subnet_id                 = element(aws_subnet.private.*.id, count.index)
  route_table_id            = aws_route_table.private.id
}

resource "aws_eip" "nat" {
  domain                    = "vpc"

  tags = {
    Name                    = "krikey-${var.environment}-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id             = aws_eip.nat.id
  subnet_id                 = aws_subnet.public.0.id

  tags = {
    Name                    = "krikey-${var.environment}-nat-gw"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.nat.id

  timeouts {
    create                  = "5m"
  }
}
