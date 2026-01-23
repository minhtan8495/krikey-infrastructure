data "aws_iam_policy_document" "krikey_task_assume_policy" {
  statement {
    effect                = "Allow"
    actions               = ["sts:AssumeRole"]

    principals {
      type                = "Service"
      identifiers         = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "krikey_task_execution_role" {
  name                    = "krikey-task-execution-role-${var.environment}"
  assume_role_policy      = data.aws_iam_policy_document.krikey_task_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "krikey_ecs_task_execution_role" {
  role                    = aws_iam_role.krikey_task_execution_role.name
  policy_arn              = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "krikey_ecs_task_get_saas_secrets" {
  name                    = "krikey-ecs-task-get-saas-secrets-${var.environment}"
  role                    = aws_iam_role.krikey_task_execution_role.id

  policy                  = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect": "Allow",
        "Resource": [
          aws_secretsmanager_secret.krikey_secrets.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "krikey_rds_access" {
  name                    = "krikey_rds_access_${var.environment}"
  path                    = "/"
  description             = "IAM policy to Access RDS"

  policy                  = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "rds-db:connect"
          ],
          "Resource": [
            aws_rds_cluster.krikey_db_cluster.arn,
            aws_rds_cluster_instance.krikey_db_cluster_instances[0].arn,
            aws_rds_cluster_instance.krikey_db_cluster_instances[1].arn
          ]
        }
    ]
  })
}

resource "aws_iam_role" "krikey_service_task_role" {
  name                    = "krikey-service-task-role-${var.environment}"
  assume_role_policy      = data.aws_iam_policy_document.krikey_task_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "service_rds_access" {
  role                    = aws_iam_role.krikey_service_task_role.name
  policy_arn              = aws_iam_policy.krikey_rds_access.arn
}
