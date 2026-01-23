variable "region" {
  description       = "The region to launch the bastion host"
}

variable "environment" {
  description       = "The environment"
}

variable "availability_zones" {
  type              = list
  description       = "The az that the resources will be launched"
}

variable "rds_availability_zones" {
  type              = list
  description       = "The az that the RDS will be launched"
}

variable "aws_vpc_id" {
  description       = "aws vpc id"
}

variable "default_subnet_id" {
  description       = "aws vpc default subnets"
}

variable "rds_subnet_id" {
  description       = "rds subnets"
}

variable "public_subnet_id" {
  type              = list
  description       = "public subnets"
}

variable "private_subnet_id" {
  type              = list
  description       = "private subnets"
}

variable "db_root_user" {
  description       = "Aurora DB Root Username"
}

variable "db_name" {
  description       = "Aurora DB name"
}
