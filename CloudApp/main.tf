############
# Module VPC
############
data "aws_availability_zones" "az" {
  state = "available"
}

module "vpc-reg1" {
  source                        = "../modules/VPC"
  enable_vpc                    = true
  vpc_cidr                      = var.vpc_cidr
  enable_dns_hostnames          = true
  enable_dns_support            = true
  enable_internet_gateway       = true
  vpc_id                        = var.vpc_id
  private_subnet_cidrs          = var.private_subnets
  public_subnet_cidrs           = var.public_subnets
  enable_nat_gateway            = true
  nat_gateway_subnet_id         = var.nat_gateway_subnet_id
  nat_gateway_connectivity_type = var.connectivity_type
  resource_tags = {
    name = "var.proyecto"
  }
}

