resource "aws_elastic_beanstalk_application" "gitbucket" {
  name        = "gitbucket"
  description = "GitBucket application deployed via Elastic Beanstalk"
}

resource "aws_security_group" "beanstalk_sg" {
  name        = "beanstalk-sg"
  description = "Security group for Elastic Beanstalk"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "beanstalk-sg"
  }
}


resource "aws_iam_role" "aws_elasticbeanstalk_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_elasticbeanstalk_ec2_role_policies" {
  role       = aws_iam_role.aws_elasticbeanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "aws_elasticbeanstalk_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role"
  role = aws_iam_role.aws_elasticbeanstalk_ec2_role.name
}

resource "aws_iam_role" "aws_elasticbeanstalk_service_role" {
  name = "aws-elasticbeanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "elasticbeanstalk.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_elasticbeanstalk_service_role_policy" {
  role       = aws_iam_role.aws_elasticbeanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}




resource "aws_elastic_beanstalk_environment" "gitbucket_env" {
  name                = "gitbucket-env"
  application         = aws_elastic_beanstalk_application.gitbucket.name
  solution_stack_name = "64bit Amazon Linux 2023 v5.3.2 running Tomcat 9 Corretto 17"
  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = module.vpc.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", module.vpc.public_subnets) 
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", module.vpc.public_subnets)  
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.beanstalk_sg.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CATALINA_BASE_PORT"
    value     = "5000"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.aws_elasticbeanstalk_service_role.arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.aws_elasticbeanstalk_ec2_role.name
  }
  
  version_label = aws_elastic_beanstalk_application_version.gitbucket_version.name
}
/*
resource "aws_elastic_beanstalk_application_version" "gitbucket_version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.gitbucket.name
  bucket      = aws_s3_bucket.gitbucket_war.bucket
  key         = aws_s3_object.gitbucket_war.key
}

resource "aws_s3_bucket" "gitbucket_war" {
  bucket = "gitbucket-deploy-bucket"
}

resource "aws_s3_object" "gitbucket_war" {
  bucket = aws_s3_bucket.gitbucket_war.bucket
  key    = "gitbucket.war"
  source = var.war_file_path
}*/

resource "aws_elastic_beanstalk_application_version" "gitbucket_version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.gitbucket.name
  bucket      = "gitbucket-deploy-bucket"
  key         = "gitbucket.war"
}

# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "gitbucket-terraform-state"
    key     = "build/terraform.tfstate"
    region  = "eu-central-1"
  }
}


