output "krikey_ecs_cluster_name" {
  value               = aws_ecs_cluster.krikey_cluster.name
}

output "krikey_ecs_service_name" {
  value               = aws_ecs_service.krikey_service.name
}

output "krikey_ecr_repo_name" {
  value               = aws_ecr_repository.krikey_service.name
}

output "krikey_frontend_bucket_name" {
  value               = aws_s3_bucket.krikey_frontend_bucket.bucket
}

output "krikey_cloudfront_id" {
  value               = aws_cloudfront_distribution.krikey_fe_distribution.id
}

output "krikey_rds_access_iam_policy_arn" {
  value               = aws_iam_policy.krikey_rds_access.arn
}

output "krikey_db_host" {
  value               = aws_rds_cluster.krikey_db_cluster.endpoint
}

output "krikey_db_port" {
  value               = aws_rds_cluster.krikey_db_cluster.port
}

output "krikey_db_name" {
  value               = aws_rds_cluster.krikey_db_cluster.database_name
}
output "krikey_db_user" {
  value               = aws_rds_cluster.krikey_db_cluster.master_username
}

output "krikey_db_password" {
  value               = random_password.master_password.result
}

output "krikey_db_engine" {
  value               = aws_rds_cluster.krikey_db_cluster.engine
}
