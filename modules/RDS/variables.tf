variable "environment" {
  description = "The Deployment environment"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}

variable "eks_cluster_name" {
  description = "EKS Cluster"
}

variable "ecr_repository_name" {
  description = "Repository Name"
}

variable "private_subnets_id" {
  description = "Private Subnets Ids"
}

variable "db_instance_identifier" {
  description = "The identifier for the RDS MySQL database instance."
}

variable "db_instance_username" {
  description = "The username for the RDS MySQL database."
}

variable "db_instance_password" {
  description = "The password for the RDS MySQL database."
}