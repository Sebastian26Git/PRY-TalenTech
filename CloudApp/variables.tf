variable "vpc_id" {
  type    = string
  default = null
}

variable "vpc_cidr" {
  type = string
}


variable "private_subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone_index = number
    is_twg_attachment       = bool
  }))
}

variable "public_subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone_index = number
    is_twg_attachment       = bool
  }))
  default = {}
}

variable "nat_gateway_subnet_id" {
  type    = string
  default = ""
}

variable "connectivity_type" {
  type    = string
  default = ""
}

variable "transit_gateway_id" {
  type        = string
  default     = null
  description = "(Required) Identifier of EC2 Transit Gateway."
}
