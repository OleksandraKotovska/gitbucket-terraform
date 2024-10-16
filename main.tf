provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                  = "./modules/vpc"
  vpc_name                = "beanstalk-vpc"
  vpc_cidr                = var.vpc_cidr
  private_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets          = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "Name" = "beanstalk-public"
  }

  private_subnet_tags = {
    "Name" = "beanstalk-private"
  }
}

module "rds" {
  source                       = "./modules/rds"
  vpc_id                       = module.vpc.vpc_id
  public_subnets               = module.vpc.public_subnets
  security_group_name          = "rds_security_group"
  subnet_group_name            = "rds-subnet-group"
  db_credentials_secret_name   = "db-credentials"
  db_identifier                = "myrds"
  db_instance_name             = "mariadb-instance"
  allocated_storage             = 10
  engine_version               = "10.6.14"
  instance_class               = "db.t3.micro"
  skip_final_snapshot          = true
  publicly_accessible          = true
}

module "beanstalk" {
  source                = "./modules/beanstalk"
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  application_name      = "gitbucket"
  application_description = "GitBucket application deployed via Elastic Beanstalk"
  environment_name      = "gitbucket-env"
  solution_stack_name   = "64bit Amazon Linux 2023 v5.3.2 running Tomcat 9 Corretto 17"
  security_group_name   = "beanstalk-sg"
  instance_type         = "t3.micro"
  environment_type      = "SingleInstance"
  war_bucket            = "gitbucket-deploy-bucket"
  war_key               = "gitbucket.war"
}

terraform {
  backend "s3" {
    bucket  = "gitbucket-terraform-state"
    key     = "build/terraform.tfstate"
    region  = "eu-central-1"
  }
}
