###############
# Variables VPC
###############
region               = "us-east-1"
environment          = "Proyecto-TalentoTech"
vpc_cidr             = "10.130.0.0/16"
public_subnets_cidr  = ["10.130.0.0/26", "10.130.0.64/26"]
private_subnets_cidr = ["10.130.0.128/26", "10.130.0.192/26"]

###############
# Variables RDS
###############

userdb   = "admin"
password = "admin123."
