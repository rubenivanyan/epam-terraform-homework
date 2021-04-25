terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "/home/ruben/credentials"
  profile                 = "default"
}
resource "aws_security_group" "allow_http_https_ssh" {
  name        = "allow_http_https_ssh"
  description = "Allow http, https & ssh inbound traffic"
  vpc_id      = "vpc-05bf3d6e"

  ingress {
    description      = "HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
resource "local_file" "config" {
 content = templatefile("inventory",
 {
  public_ip=aws_instance.myec2.public_ip
 }
 )
 filename = "/home/ruben/terraform-homework/homework-1/inventory"
}
resource "aws_instance" "myec2" {
  ami           = "ami-08962a4068733a2b6"
  instance_type = "t2.micro"
  key_name = "terraform"
  vpc_security_group_ids = ["${aws_security_group.allow_http_https_ssh.id}"]
  
  provisioner "local-exec" {
    command = "ansible-playbook -i  inventory playbook.yml"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file ("/home/ruben/terraform.pem")
    host = self.public_ip
  }
}

