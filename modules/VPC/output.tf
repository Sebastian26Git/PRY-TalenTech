output "vpc_id" {
  description = "The ID of the VPC"
  value       = element(concat(aws_vpc.vpc[*].id, [""]), 0)
}

output "public_subnets_ids" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnets

}

output "private_subnets_ids" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnets

}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw[*].id
}

output "nat_gateway_id" {
  description = "nat gateway id"
  value       = aws_nat_gateway.nat_gateway[*].id

}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}

