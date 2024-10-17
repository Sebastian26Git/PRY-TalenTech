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
  name_prefix = "rds-instance"
}
module "rds" {
  source                    = "terraform-aws-modules/rds/aws"
  identifier                = "cloudapp-rds-instance"
  engine                    = "mysql"
  major_engine_version      = "8.0"
  family                    = "mysql8.0"
  instance_class            = "db.t3.micro"
  allocated_storage         = 20
  username                  = var.userdb # recomendable cambiar el usuario y la contraseña por defecto
  password                  = var.password
  port                      = 3306
  multi_az                  = true
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.rds_security_group.id]
  create_db_option_group    = false
  create_db_parameter_group = false

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
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


############
# Module EKS
############
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "cloud-app-talento-tech"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = { resolve_conflict = "OVERWRITE" }
    eks-pod-identity-agent = { resolve_conflict = "OVERWRITE" }
    kube-proxy             = { resolve_conflict = "OVERWRITE" }
    vpc-cni                = { resolve_conflict = "OVERWRITE" }
  }

  vpc_id                   = module.vpc-reg1.vpc_id
  subnet_ids               = module.vpc-reg1.private_subnets_id
  control_plane_subnet_ids = module.vpc-reg1.private_subnets_id

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]
      disk_size      = 100
    }

    scaling_config = {
      enabled      = true
      min_size     = 1
      max_size     = 4
      desired_size = 2
    }
  }


  # Cluster access entry
  # To add the current caller identity as an administrator  
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::632333029035:role/eksro"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["Proyecto"]
            type       = "namespace"
          }
        }
      }
    }
  }

  
  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}