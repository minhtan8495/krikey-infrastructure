resource "aws_default_security_group" "default" {
  vpc_id                  = var.aws_vpc_id

  ingress {
    protocol              = -1
    self                  = true
    from_port             = 0
    to_port               = 0
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "krikey_lb_sg" {
  name                    = "krikey-lb-sg-${var.environment}"
  description             = "External access to the application load balancer"
  vpc_id                  = var.aws_vpc_id

  ingress {
    protocol              = "tcp"
    from_port             = 80
    to_port               = 80
    cidr_blocks           = ["0.0.0.0/0"]
  }

  ingress {
    protocol              = "tcp"
    from_port             = 443
    to_port               = 443
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    protocol              = "-1"
    from_port             = 0
    to_port               = 0
    cidr_blocks           = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name                    = "krikey-ecs-sg-${var.environment}"
  description             = "Allow inbound access from the ALB only"
  vpc_id                  = var.aws_vpc_id

  ingress {
    protocol              = "tcp"
    from_port             = 3000
    to_port               = 3000
    cidr_blocks           = ["0.0.0.0/0"]
    security_groups       = [aws_security_group.krikey_lb_sg.id]
  }

  egress {
    protocol              = "-1"
    from_port             = 0
    to_port               = 0
    cidr_blocks           = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "krikey_rds_sg" {
  name                    = "krikey-rds-sg-${var.environment}"
  description             = "Allow RDS Access"
  vpc_id                  = var.aws_vpc_id

  ingress {
    protocol              = "tcp"
    from_port             = 5432
    to_port               = 5432
    cidr_blocks           = ["0.0.0.0/0"]
  }
  ingress {
    protocol              = "udp"
    from_port             = 5432
    to_port               = 5432
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    protocol              = "-1"
    from_port             = 0
    to_port               = 0
    cidr_blocks           = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "krikey_redis_sg" {
	name                							= "krikey-redis-sg-${var.environment}"
	description         							= "Allow Redis Access"
	vpc_id              							= var.aws_vpc_id

	ingress {
		protocol        								= "tcp"
		from_port       								= 6379
		to_port         								= 6379
		cidr_blocks     								= ["0.0.0.0/0"]
	}
	ingress {
		protocol        								= "udp"
		from_port       								= 6379
		to_port         								= 6379
		cidr_blocks     								= ["0.0.0.0/0"]
	}

	egress {
		protocol        								= "-1"
		from_port       								= 0
		to_port         								= 0
		cidr_blocks     								= ["0.0.0.0/0"]
	}
}
