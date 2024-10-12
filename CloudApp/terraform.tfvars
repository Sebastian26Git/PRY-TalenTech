###############
# Variables VPC
###############
vpc_cidr = "10.130.0.0/24"
private_subnets = {

  "subnet-private-az1" = {
    cidr_block              = "10.130.0.0/26"
    availability_zone_index = 0
    is_twg_attachment = false
  }

  "subnet-private-az2" = {
    cidr_block              = "10.130.0.64/26"
    availability_zone_index = 1
    is_twg_attachment = false
  }
}

public_subnets = {

  "subnet-public-az1" = {
    cidr_block              = "10.130.0.128/26"
    availability_zone_index = 0
    is_twg_attachment = false
  }

  "subnet-public-az2" = {
    cidr_block              = "10.130.0.192/26"
    availability_zone_index = 1
    is_twg_attachment = false
  }
}

