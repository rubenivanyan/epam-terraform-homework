resource "aws_launch_configuration" "wordpress_lc" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "ami-08962a4068733a2b6"
  instance_type = "t2.micro"
  security_groups = [ aws_security_group.main_sg.id ]
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wordpress_asg" {
  name                 = "wordpress_asg"
  min_size             = 2
  max_size             = 5
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.wordpress_lc.name
  vpc_zone_identifier       = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  tags = [ {
    "Name" = "NEW"
  } ]
  
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
  alb_target_group_arn   = aws_lb_target_group.wordpress.arn
}