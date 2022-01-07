#Frontend
resource "aws_lb" "frontend_load_balancer" {
  name               = "Frontend-Load-Balancer"
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  internal           = false
  security_groups = [
    aws_security_group.alb_security_group.id
  ]
  subnets = [
    data.terraform_remote_state.network_configuration.outputs.public_subnet_1_id,
    data.terraform_remote_state.network_configuration.outputs.public_subnet_2_id,
    data.terraform_remote_state.network_configuration.outputs.public_subnet_3_id
  ]
}

resource "aws_lb_target_group" "frontend_target_group" {
  name        = "frontend"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.network_configuration.vpc_id

  health_check {
    interval            = 10
    path                = "index.html"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "frontend" {
  target_group_arn = aws_lb_target_group.frontend_target_group.arn
  target_id        = var.asg_public_id
  port             = 80
}

#Backend
resource "aws_lb" "backend_load_balancer" {
  name               = "Backend-Load-Balancer"
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  internal           = true
  security_groups = [
    aws_security_group.alb_security_group.id
  ]
  subnets = [
    data.terraform_remote_state.network_configuration.outputs.private_subnet_1_id,
    data.terraform_remote_state.network_configuration.outputs.private_subnet_2_id,
    data.terraform_remote_state.network_configuration.outputs.private_subnet_3_id
  ]
}

resource "aws_lb_target_group" "backend_target_group" {
  name        = "backend"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.network_configuration.vpc_id

  health_check {
    interval            = 10
    path                = "index.html"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.backend_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "backend" {
  target_group_arn = aws_lb_target_group.backend_target_group.arn
  target_id        = var.asg_private_id
  port             = 80
}
