resource "aws_cloudwatch_log_group" "krikey_log_group" {
  name                  = "awslogs-krikey-${var.environment}"
  retention_in_days     = 7

  tags = {
    Environment         = var.environment
  }
}
