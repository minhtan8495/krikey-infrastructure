resource "random_password" "master_password" {
  length                      = 16
  special                     = false
}

resource "aws_secretsmanager_secret" "krikey_secrets" {
  name                        = "krikey/secrets_${var.environment}"
}

resource "aws_secretsmanager_secret_version" "krikey_secrets" {
  secret_id                   = aws_secretsmanager_secret.krikey_secrets.id
  secret_string               = <<EOF
{
  "appEnv": "${var.environment}",
  "host": "${aws_rds_cluster.krikey_db_cluster.endpoint}",
  "port": "${aws_rds_cluster.krikey_db_cluster.port}",
  "dbname": "${aws_rds_cluster.krikey_db_cluster.database_name}",
  "username": "${aws_rds_cluster.krikey_db_cluster.master_username}",
  "password": "${random_password.master_password.result}",
  "engine": "${aws_rds_cluster.krikey_db_cluster.engine}"
}
EOF
}
