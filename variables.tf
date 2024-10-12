variable "aws_region" {
  default = "eu-central-1"
  description = "aws region"
}
variable "war_file_path" {
  description = "Path to the GitBucket WAR file"
  default     = "/home/oleksandra/beanstalk/gitbucket.war" 
}
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "ami_id" {
  description = "AMI ID for the EKS node group"
  type        = string
  default     = "ami-06c9b733e04508ebf"
}
