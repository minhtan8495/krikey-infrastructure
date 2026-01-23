output "public_route_table" {
  value = aws_default_route_table.public.id
}

output "aws_vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_default" {
  value = aws_subnet.default.*.id
}

output "rds_subnet_id" {
  value = aws_subnet.krikey_rds.*.id
}

output "public_subnet_id" {
  value = aws_subnet.public.*.id
}

output "private_subnet_id" {
  value = aws_subnet.private.*.id
}
