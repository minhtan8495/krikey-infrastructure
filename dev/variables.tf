variable "region" {
  description       = "Region"
}

variable "environment" {
  description       = "The environment"
}

variable "profile" {
  description       = "The AWS profile"
}

variable "vpc_cidr" {
  description       = "The CIDR block of the vpc"
}

variable "rds_subnet_cidr" {
  description       = "The CIDR block of the RDS"
}

variable "public_subnets_cidr" {
  type              = list
  description       = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type              = list
  description       = "The CIDR block for the private subnet"
}

variable "db_name" {
  description       = "Aurora DB name"
}

variable "db_root_user" {
  description       = "Aurora DB Root Username"
}

variable "codestar_connection_arn" {
  description       = "AWS CodeStar Connection ARN"
}

variable "backend_repository_id" {
  description       = "AWS Connection Backend Repository Id"
}

variable "backend_branch_name" {
  description       = "Branch name"
}

variable "frontend_repository_id" {
  description       = "AWS Connection Frontend Repository Id"
}

variable "frontend_branch_name" {
  description       = "Branch name"
}

variable "memory_reserv" {
  default           = 100
}
