variable "region" {
  description   = "The region to launch the bastion host"
}

variable "environment" {
  description   = "The environment"
}

variable "repo_name" {
  description   = "ECR Repository name"
}

variable "container_name" {
  description   = "Docker container name"
}

variable "aws_ecs_cluster_name" {
  description   = "AWS ECS Cluster name"
}

variable "aws_ecs_service_name" {
  description   = "AWS ECS Service name"
}

variable "krikey_frontend_bucket_name" {
  description   = "Frontend Bucket name"
}

variable "krikey_cloudfront_id" {
  description   = "Frontend CloudFront Id"
}

variable "codestar_connection_arn" {
  description   = "The ARN of Codestar connection"
}

variable "backend_repository_id" {
  description   = "Backend Repository Id"
}

variable "backend_branch_name" {
  description   = "Backend Branch name"
}

variable "frontend_repository_id" {
  description   = "Frontend Repository Id"
}

variable "frontend_branch_name" {
  description   = "Frontend branch name"
}
