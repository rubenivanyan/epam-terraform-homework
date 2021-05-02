#Create VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "new"
  cidr                 = "10.10.0.0/16"
  azs                  = ["us-east-2a", "us-east-2b"]
  public_subnets       = ["10.10.10.0/24", "10.10.20.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "new"
  }
}
#Create DB subnet group
resource "aws_db_subnet_group" "new-rds" {
  name       = "new-rds"
  subnet_ids = module.vpc.public_subnets
}
