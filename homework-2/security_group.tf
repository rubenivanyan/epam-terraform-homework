locals {
  vpc_id = module.vpc.vpc_id
  sec_group_lb_to_ec2 = ["${aws_security_group.wordpress_sg.id}"]
  sec_group_ec2_to_rds = ["${aws_security_group.main_sg.id}"]
}
resource "aws_security_group" "main_sg" {
  name        = "main_sg"
  description = "Allow http, https & ssh inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "HTTPS from load_balancer"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = local.sec_group_lb_to_ec2
  }
  ingress {
    description = "HTTP from load_balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups  =  local.sec_group_lb_to_ec2
  }
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [module.vpc]
}
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow http, https inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [module.vpc]
}
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow connection to database"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups  =  local.sec_group_ec2_to_rds


}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [module.vpc]
}