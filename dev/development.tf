terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_availability_zones" "available" {
  state                               = "available"
}

/*====
Variables used across all modules
======*/
locals {
  development_availability_zones      = data.aws_availability_zones.available.names
  rds_availability_zones              = ["us-east-1a", "us-east-1b"]
}

module "network" {
  source                              = "../modules/network"
  region                              = var.region
  availability_zones                  = local.development_availability_zones
  rds_availability_zones              = local.rds_availability_zones
  environment                         = var.environment
  vpc_cidr                            = var.vpc_cidr
  rds_subnet_cidr                     = var.rds_subnet_cidr
  public_subnets_cidr                 = var.public_subnets_cidr
  private_subnets_cidr                = var.private_subnets_cidr
}

module "krikey" {
  source                              = "../modules/krikey"

  region                              = var.region
  environment                         = var.environment

  availability_zones                  = local.development_availability_zones
  rds_availability_zones              = local.rds_availability_zones

  db_root_user                        = var.db_root_user
  db_name                             = var.db_name

  aws_vpc_id                          = module.network.aws_vpc_id
  default_subnet_id                   = module.network.subnet_default
  rds_subnet_id                       = module.network.rds_subnet_id
  public_subnet_id                    = module.network.public_subnet_id
  private_subnet_id                   = module.network.private_subnet_id
}

module "pipeline" {
  source                              = "../modules/pipeline"

  region                              = var.region
  environment                         = var.environment

  repo_name                           = module.krikey.krikey_ecr_repo_name
  container_name                      = "krikey_service"
  aws_ecs_cluster_name                = module.krikey.krikey_ecs_cluster_name
  aws_ecs_service_name                = module.krikey.krikey_ecs_service_name

  codestar_connection_arn             = var.codestar_connection_arn
  backend_repository_id               = var.backend_repository_id
  backend_branch_name                 = var.backend_branch_name
  frontend_repository_id              = var.frontend_repository_id
  frontend_branch_name                = var.frontend_branch_name

  krikey_frontend_bucket_name         = module.krikey.krikey_frontend_bucket_name
  krikey_cloudfront_id                = module.krikey.krikey_cloudfront_id
}
