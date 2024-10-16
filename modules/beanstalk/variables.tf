variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets for the Beanstalk environment"
  type        = list(string)
}

variable "application_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
  default     = "gitbucket"  # Default value
}

variable "application_description" {
  description = "Description of the Elastic Beanstalk application"
  type        = string
  default     = "GitBucket application deployed via Elastic Beanstalk"  # Default value
}

variable "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  type        = string
  default     = "gitbucket-env"  # Default value
}

variable "solution_stack_name" {
  description = "The solution stack for the Elastic Beanstalk environment"
  type        = string
  default     = "64bit Amazon Linux 2023 v5.3.2 running Tomcat 9 Corretto 17"  # Default value
}

variable "security_group_name" {
  description = "Name of the Beanstalk security group"
  type        = string
  default     = "beanstalk-sg"  # Default value
}

variable "instance_type" {
  description = "The instance type for the Elastic Beanstalk environment"
  type        = string
  default     = "t3.micro"  # Default value
}

variable "environment_type" {
  description = "Type of the Elastic Beanstalk environment"
  type        = string
  default     = "SingleInstance"  # Default value
}

variable "war_bucket" {
  description = "The S3 bucket where the WAR file is stored"
  type        = string
  default     = "gitbucket-deploy-bucket"  # Default value
}

variable "war_key" {
  description = "The key for the WAR file in the S3 bucket"
  type        = string
  default     = "gitbucket.war"  # Default value
}

variable "version_label" {
  description = "The version label for the application version"
  type        = string
  default     = "v1"  # Default value
}
