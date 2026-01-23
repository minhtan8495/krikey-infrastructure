resource "aws_ecs_cluster" "krikey_cluster" {
  name                          = "krikey_cluster_${var.environment}"

  setting {
    name                        = "containerInsights"
    value                       = "enabled"
  }
}

resource "aws_ecs_service" "krikey_service" {
  name                          = "krikey_service_${var.environment}"
  cluster                       = aws_ecs_cluster.krikey_cluster.id
  task_definition               = aws_ecs_task_definition.krikey_service_task_def.arn
  desired_count                 = 1
  launch_type                   = "FARGATE"

  network_configuration {
    security_groups             = [aws_security_group.ecs_tasks.id]
    subnets                     = var.default_subnet_id
    assign_public_ip            = true
  }

  load_balancer {
    target_group_arn            = aws_lb_target_group.krikey_service_lb_target_group.arn
    container_name              = "krikey_service"
    container_port              = 3000
  }

  depends_on = [
    aws_lb_target_group.krikey_service_lb_target_group,
    aws_lb_listener.krikey_service_http_forward,
    # aws_lb_listener.krikey_service_https_forward,
    aws_iam_role_policy_attachment.krikey_ecs_task_execution_role,
    aws_iam_role.krikey_service_task_role
  ]

  lifecycle {
    ignore_changes              = [task_definition, desired_count]
  }

  tags = {
    Environment                 = var.environment
  }
}

resource "aws_ecs_task_definition" "krikey_service_task_def" {
  family                        = "krikey_service_task_def_${var.environment}"
  task_role_arn                 = aws_iam_role.krikey_service_task_role.arn
  execution_role_arn            = aws_iam_role.krikey_task_execution_role.arn
  network_mode                  = "awsvpc"
  cpu                           = "2048"
  memory                        = "4096"
  requires_compatibilities      = ["FARGATE"]

  container_definitions         = <<-EOT
    [
      {
        "name": "krikey_service",
        "image": "${aws_ecr_repository.krikey_service.repository_url}:latest",
        "essential": true,
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "krikey-service",
            "awslogs-group": "${aws_cloudwatch_log_group.krikey_log_group.name}"
          }
        },
        "portMappings": [
          {
            "containerPort": 3000,
            "hostPort": 3000,
            "protocol": "tcp"
          }
        ],
        "environment": [
          ${local.ecs_krikey_service_container_definitions_environment_json}
        ],
        "secrets": [
          ${local.ecs_krikey_service_container_secrets_json}
        ],
        "ulimits": [
          {
            "name": "nofile",
            "softLimit": 65536,
            "hardLimit": 65536
          }
        ],
        "mountPoints": [],
        "volumesFrom": []
      }
    ]
  EOT
}
