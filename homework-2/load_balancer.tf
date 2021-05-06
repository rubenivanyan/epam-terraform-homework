#define local variables
locals {
  vpc_id2 = module.vpc.vpc_id
}
#Create target_group
resource "aws_lb_target_group" "wordpress" {
  name     = "wordpress"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id2
  health_check {
    path = var.health_check_path
  }

}
#Create load_balancer
resource "aws_lb" "wordpresslb" {
  name               = "wordpresslb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wordpress_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
  depends_on = [aws_security_group.wordpress_sg]
}
#Create listener
resource "aws_lb_listener" "listen80" {
  load_balancer_arn = aws_lb.wordpresslb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.wordpress.id
    type             = "forward"
  }
}
