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
locals {
  name        = "rds-instance"
}
module "rds" {
  source                 = "terraform-aws-modules/rds/aws"
  identifier             = "CloudApp-rds-instance"
  engine                 = "mysql"
  major_engine_version   = "8.0"
  family                 = "mysql8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = var.userdb # recomendable cambiar el usuario y la contraseña por defecto
  password               = var.password
  port                   = 3306
  multi_az               = true
  skip_final_snapshot    = true
  vpc_security_group_ids = aws_security_group.rds_security_group
  subnet_ids             = [module.vpc-reg1.private_subnets_id]
  tags = {
    Name     = "CloudApp-rds-instance"
    Ambiente = var.environment
  }
}


resource "aws_security_group" "rds_security_group" {
  name_prefix = "rds-sg"
  vpc_id      = module.vpc-reg1.vpc_id

  ingress {
    from_port   = 3306 # recomendable cambiar los puertos por defecto
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
 