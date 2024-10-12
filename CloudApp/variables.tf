###############
# Variables VPC
###############

variable "region" {
  description = "us-east-1"
}

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

# ###############
# # Variables RDS
# ###############
# variable "availability_zones" {
#   type        = list
#   description = "The az that the resources will be launched"
# }

# variable "eks_cluster_name" {
#   description = "EKS Cluster"
# }

# variable "ecr_repository_name" {
#   description = "Repository Name"
# }

# variable "private_subnets_id" {
#   description = "Private Subnets Ids"
# }

# variable "db_instance_identifier" {
#   description = "The identifier for the RDS MySQL database instance."
# }

# variable "db_instance_username" {
#   description = "The username for the RDS MySQL database."
# }

# variable "db_instance_password" {
#   description = "The password for the RDS MySQL database."
# }

# variable "proyecto" {
#   description = "Nombre del proyecto"
#   type        = string
#   default     = "TalenTech"
# }

# variable "multiaz"{
#   description = "Seleccion de si es Multi AZ o no"
#   type        = bool
#   default     = true
# }

# variable "version_db" {
#   description = "Version de MySQL"
#   type        = string
#   default     = "8.0"
# }

# variable "engine" {
#   description = "Engine de MySQL"
#   type        = string
#   default     = "mysql"
# }


# variable "storage_type"{
#   description = "type storage"
#   type        = string
#   default     = "gp3"

# }

# variable "instanclase"{
#   description = "type instance db RDS"
#   type        = string
#   default     = "db.t3.micro"
  
# }

# variable "allocated_storage" {
#   description = "type instance db RDS"
#   type        = number

# }

# variable "max_allocated_storage" {
#   description = "type instance db RDS"
#   type        = number
# }

