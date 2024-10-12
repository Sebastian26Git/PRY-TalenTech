############
# Module VPC
############
data "aws_availability_zones" "az" {
  state = "available"
}

locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "vpc-reg1" {
  source               = "../modules/VPC"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones
}

############
# Module RDS
############
module "rds"{
  source               = "../modules/RDS"
  identifier             = var.db_instance_identifier
  engine                 = var.engine
  version                = var.version
  port                   = 3306
  multi_az               = true
  allocated_storage      = 30
  max_allocated_storage  = 50
  username               = var.
  password               = var.db_instance_password
  db_subnet_group_name   = aws_db_subnet_group.sub_gr.name
  vpc_id               = module.vpc-reg1.vpc_id
  private_subnet_ids   = module.vpc-reg1.private_subnets
}
 