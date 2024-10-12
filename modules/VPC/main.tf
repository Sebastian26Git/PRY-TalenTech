################################
#  Autor: Sebastián Barón Rivera
#  Versión: 1.0.0
#  Fecha: 11/10/2024
################################

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "az" {
  state = "available"
}

#####
# VPC
#####
resource "aws_vpc" "vpc" {
  count                = var.enable_vpc ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.resource_tags, {
    Name = "vpc-${var.proyecto}"
  })
}



###############
# Public Subnet
###############
resource "aws_subnet" "public_subnets" {
  for_each                = { for k, v in var.public_subnet_cidrs : k => v if v != null }
  cidr_block              = each.value["cidr_block"]
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.az.names[each.value["availability_zone_index"]]

  tags = merge(var.resource_tags, {
    Name = "subnet-public-${each.key}"
  })
}

###########################
# Route Table Subnet Public
###########################
resource "aws_route_table" "public_route_table" {
  for_each = var.public_subnet_cidrs
  vpc_id   = var.vpc_id

  tags = merge(var.resource_tags, {
    Name = "public-rt-${var.proyecto}"
  })

}

#######################################
# Route Table Association Subnet Public
#######################################
resource "aws_route_table_association" "public_route_table_association" {
  for_each = var.public_subnet_cidrs

  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public_route_table[each.key].id
  depends_on = [
    aws_subnet.public_subnets,
    aws_route_table.public_route_table,
  ]
}

################
# Private Subnet
################
resource "aws_subnet" "private_subnets" {
  for_each = { for k, v in var.private_subnet_cidrs : k => v if v != null }

  cidr_block              = each.value["cidr_block"]
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.az.names[each.value["availability_zone_index"]]

  tags = merge(var.resource_tags, {
    Name = "subnet-private-${each.key}"
  })

}

############################
# Route Table Subnet private
############################
resource "aws_route_table" "private_route_table" {
  for_each = var.private_subnet_cidrs
  vpc_id   = var.vpc_id

  tags = merge(var.resource_tags, {
    Name = "private-rt-${var.proyecto}"
  })

}

########################################
# Route Table Association Subnet Private
########################################
resource "aws_route_table_association" "private_route_table_association" {
  for_each       = var.private_subnet_cidrs
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.private_route_table[each.key].id
  depends_on = [
    aws_subnet.private_subnets,
    aws_route_table.private_route_table,
  ]
}

#####
# IGW
#####
resource "aws_internet_gateway" "igw" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = var.vpc_id
  tags = {
    Name = "igw-${var.proyecto}"
  }
}

#####
# EIP
#####
resource "aws_eip" "nat_eip" {
  count = lower(var.nat_gateway_connectivity_type) == "public" ? 1 : 0
  vpc   = true
  tags = {
    Name = "eip-nat-${var.proyecto}"
  }
}


#############
# Nat Gateway
#############
resource "aws_nat_gateway" "nat_gateway" {
  count             = var.enable_nat_gateway ? 1 : 0
  subnet_id         = var.nat_gateway_subnet_id
  allocation_id     = lower(var.nat_gateway_connectivity_type) == "public" ? element(concat(aws_eip.nat_eip[*].id, [""]), 0) : null
  connectivity_type = var.nat_gateway_connectivity_type

  tags = merge(var.resource_tags, {
    Name = "${var.proyecto}-nat-gateway"
  })
  depends_on = [
    aws_eip.nat_eip
  ]
}


###################
# Route Nat Gateway
###################
resource "aws_route" "nat_gateway_route" {
  for_each = var.enable_nat_gateway ? toset([for k, v in aws_subnet.private_subnets : k if !var.private_subnet_cidrs[k].skip_natgw_route]) : toset([])

  route_table_id         = aws_route_table.private_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat_gateway[*].id, 0)

  depends_on = [
    aws_route_table.private_route_table,
    aws_nat_gateway.nat_gateway
  ]
}


###################
# Route Int Gateway
###################
resource "aws_route" "internet_gateway_route" {
  for_each = var.enable_internet_gateway ? toset([for k, v in aws_subnet.public_subnets : k]) : toset([])

  route_table_id         = aws_route_table.public_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_internet_gateway.igw[*].id, 0)

  depends_on = [
    aws_route_table.public_route_table,
    aws_internet_gateway.igw
  ]
}

########
# SG VPC
########
resource "aws_security_group" "my_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-vpc-${var.proyecto}"
  }
}

###############
# VPC Flow Logs
###############
resource "aws_iam_role" "iam_role_vpc_flow_logs" {
  name = "${var.proyecto}-iam-role-vpc-flow-logs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "${var.proyecto}-iam-policy-vpc-flow-logs"
  role = aws_iam_role.iam_role_vpc_flow_logs.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.log_group.arn}:*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "${var.proyecto}-log_group-flow_log"
  retention_in_days = var.vpc_logs_retention_in_days
}

resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.iam_role_vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.log_group.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id

  tags = merge(var.resource_tags, {
    Name = "${var.proyecto}-flow_log"
  })
}