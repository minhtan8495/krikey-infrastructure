region                          = "us-east-1"
environment                     = "dev"
profile                         = "default"

/* module networking */
vpc_cidr                        = "10.0.0.0/16"
rds_subnet_cidr                 = "10.0.30.0/24"
public_subnets_cidr             = ["10.0.10.0/24"]
private_subnets_cidr            = ["10.0.20.0/24"]

/* module krikey */
db_root_user                    = "root"
db_name                         = "krikey"

codestar_connection_arn         = "arn:aws:codestar-connections:us-east-1:941966628158:connection/2fe641b6-ee99-4918-98a0-42b83c962c7c"
backend_repository_id           = "alpha-bird/krikey-backend"
backend_branch_name             = "dev"

frontend_repository_id          = "alpha-bird/krikey-frontend"
frontend_branch_name            = "dev"
