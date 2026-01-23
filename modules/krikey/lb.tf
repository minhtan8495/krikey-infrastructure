resource "aws_lb" "krikey_service_lb" {
  name                        = "krikey-service-alb-${var.environment}"
  load_balancer_type          = "application"

  subnets                     = var.default_subnet_id
  security_groups             = [aws_security_group.krikey_lb_sg.id]

  tags = {
    Environment               = var.environment
  }
}

resource "aws_lb_target_group" "krikey_service_lb_target_group" {
  name                        = "krikey-service-lb-target-${var.environment}"
  port                        = 80
  protocol                    = "HTTP"
  vpc_id                      = var.aws_vpc_id
  target_type                 = "ip"
  deregistration_delay        = 60

  health_check {
    path                      = "/"
  }
}

resource "aws_lb_listener" "krikey_service_http_forward" {
  load_balancer_arn           = aws_lb.krikey_service_lb.arn
  port                        = "80"
  protocol                    = "HTTP"

  default_action {
    type                      = "forward"
    target_group_arn          = aws_lb_target_group.krikey_service_lb_target_group.arn
  }
}

# resource "aws_lb_listener" "krikey_service_https_forward" {
#   load_balancer_arn           = aws_lb.krikey_service_lb.arn
#   port                        = "443"
#   protocol                    = "HTTPS"
#   ssl_policy                  = "ELBSecurityPolicy-2016-08"

#   default_action {
#     type                      = "forward"
#     target_group_arn          = aws_lb_target_group.krikey_service_lb_target_group.arn
#   }
# }
