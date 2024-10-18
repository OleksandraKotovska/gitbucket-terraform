resource "aws_security_group" "rds_sg" {
  name        = var.security_group_name
  description = "Allow Beanstalk instances to connect to RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow traffic from Beanstalk"
    from_port   = 3306
    to_port     = 3306
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
    Name = var.security_group_name
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.public_subnets

  tags = {
    Name = var.subnet_group_name
  }
}

data "aws_secretsmanager_secret" "db_credentials" {
  name = var.db_credentials_secret_name
}

data "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_version.secret_string)
}

resource "aws_db_instance" "myrds" {
  engine               = var.db_engine
  identifier           = var.db_identifier
  allocated_storage    = var.allocated_storage
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = local.db_credentials["username"]
  password             = local.db_credentials["password"]
  skip_final_snapshot  = var.skip_final_snapshot
  publicly_accessible  = var.publicly_accessible

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = var.db_instance_name
  }
}

/*resource "null_resource" "create_gitbucketdb" {
  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${aws_db_instance.myrds.address} -P 3306 -u ${local.db_credentials["username"]} -p"${local.db_credentials["password"]}" -e "CREATE DATABASE IF NOT EXISTS gitbucketdb;"
    EOT
  }

  depends_on = [aws_db_instance.myrds]
}*/

