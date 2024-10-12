variable "region" {
  description = "La región donde se desplegará la infraestructura"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block para la subred pública"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block para la subred privada"
  default     = "10.0.2.0/24"
}

variable "resource_tags" {
 type = map(string)
    description = "Tags para los recursos"
    default = {
        project_name = "TalenTech"
    }
}

variable "enable_vpc"{
    type = bool
    description = "Enable VPC creation"
    default = true
}

variable "enable_dns_support" {
    type = bool
    description = "Enable DNS support"
    default = true
}

variable "enable_dns_hostnames" {
    type = bool
    description = "Enable DNS hostnames"
    default = true
}

variable "proyecto"{
    type = string
    description = "Nombre del proyecto"
    default = "TalenTech"
}


variable "private_subnet_cidrs" {
  type    = map(any)
  description = "CIDR block para la subred privada"
  default = {}
}


variable "public_subnet_cidrs" {
  type    = map(any)
  description = "CIDR block para la subred pública"
  default = {}
}


variable "nat_gateway_connectivity_type" {
  type        = string
  description = "nat_gateway_connectivity_type"
  default     = ""
}


variable "vpc_logs_retention_in_days" {
  type        = number
  default     = 90
  description = "Retención de logs en días"
}

variable "enable_internet_gateway" {
  type        = bool
  description = "Enables the creation of internet gateway"
  default     = false
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enables the creation of nat gateway"
  default     = false
}

variable "nat_gateway_subnet_id" {
  type        = string
  default     = null
  description = "(Required) The Subnet ID of the subnet in which to place the gateway."
}