output "beanstalk_application_name" {
  description = "The name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.gitbucket.name
}

output "beanstalk_environment_name" {
  description = "The name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.gitbucket_env.name
}
output "beanstalk_environment_url" {
  description = "URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.gitbucket_env.endpoint_url
}
