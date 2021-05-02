#define local variables
locals {
  sec_group = ["${aws_security_group.main_sg.id}"]
  first_subnet = element(module.vpc.public_subnets, 0)
  second_subnet = element(module.vpc.public_subnets, 1)

}
#Create 2 ec2 instances
resource "aws_instance" "myec2_1" {
  ami                    = "ami-08962a4068733a2b6"
  instance_type          = "t2.micro"
  key_name               = "terraform"
  vpc_security_group_ids = local.sec_group
  subnet_id              = local.first_subnet
  tags = {
    "Name" = "NEW"
  }
  depends_on = [aws_security_group.main_sg]
}
resource "aws_instance" "myec2_2" {
  ami                    = "ami-08962a4068733a2b6"
  instance_type          = "t2.micro"
  key_name               = "terraform"
  vpc_security_group_ids = local.sec_group
  subnet_id              = local.second_subnet

  depends_on = [module.vpc]
}
#Create inventory file
resource "local_file" "inventory" {
  content = templatefile("inventory.template",
    {
      public_ip_1 = aws_instance.myec2_1.public_ip
      public_ip_2 = aws_instance.myec2_2.public_ip
    }
  )
  filename = "inventory"
}
#Create db_connection_config file
resource "local_file" "dbhostname" {
  content = templatefile("${var.configpath}",
    {
      dbhostname = aws_db_instance.default.address
    }
  )
  filename = "dbhostname"
}
