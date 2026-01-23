resource "aws_rds_cluster_instance" "krikey_db_cluster_instances" {
  count                           = 2
  identifier                      = "krikey-aurora-cluster-${var.environment}-${count.index}"
  cluster_identifier              = aws_rds_cluster.krikey_db_cluster.id
  instance_class                  = "db.r5.large"

  engine                          = aws_rds_cluster.krikey_db_cluster.engine
  engine_version                  = aws_rds_cluster.krikey_db_cluster.engine_version

  publicly_accessible             = true
}

resource "aws_rds_cluster" "krikey_db_cluster" {
  cluster_identifier              = "krikey-aurora-cluster-${var.environment}"

  db_subnet_group_name            = aws_db_subnet_group.krikey_db_subnet_group.name
  vpc_security_group_ids          = [aws_security_group.krikey_rds_sg.id]

  engine                          = "aurora-postgresql"
  engine_version                  = "14.5"

  database_name                   = var.db_name
  master_username                 = var.db_root_user
  master_password                 = random_password.master_password.result

  backup_retention_period         = 5
  preferred_backup_window         = "07:00-09:00"
  skip_final_snapshot             = true
  kms_key_id                      = aws_kms_key.krikey_db_kms_key.arn
  storage_encrypted               = true
}

resource "aws_db_subnet_group" "krikey_db_subnet_group" {
  name                            = "krikey-db-subnet-group-${var.environment}"
  subnet_ids                      = var.rds_subnet_id
}

resource "aws_kms_key" "krikey_db_kms_key" {
  description                     = "Krikey RDS KMS Key"
  deletion_window_in_days         = 10
}
