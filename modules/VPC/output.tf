output "vpc_id" {
  description = "The ID of the VPC"
  value       = element(concat(aws_vpc.vpc[*].id, [""]), 0)
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}

