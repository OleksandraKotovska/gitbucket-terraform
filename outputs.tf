output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

# RDS Outputs
output "rds_address" {
  value = module.rds.rds_address
}

# Beanstalk Outputs
output "beanstalk_application_name" {
  value = module.beanstalk.beanstalk_application_name
}

output "beanstalk_environment_name" {
  value = module.beanstalk.beanstalk_environment_name
}
output "beanstalk_environment_url" {
  value = module.beanstalk.beanstalk_environment_url
}

