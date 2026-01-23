variable "region" {
  description   = "The region to launch the bastion host"
}

variable "environment" {
  description   = "The environment"
}

variable "availability_zones" {
  type          = list
  description   = "The az that the resources will be launched"
}

variable "rds_availability_zones" {
  type          = list
  description   = "The az that the RDS will be launched"
}

variable "vpc_cidr" {
  description   = "The CIDR block of the vpc"
}

variable "rds_subnet_cidr" {
  description   = "The CIDR block of the RDS"
}

variable "public_subnets_cidr" {
  type          = list
  description   = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type          = list
  description   = "The CIDR block for the private subnet"
}
