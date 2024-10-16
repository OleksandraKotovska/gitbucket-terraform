variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets for the RDS subnet group"
  type        = list(string)
}

variable "security_group_name" {
  description = "Name of the RDS security group"
  type        = string
  default     = "rds_security_group"  # Default value
}

variable "subnet_group_name" {
  description = "Name of the RDS subnet group"
  type        = string
  default     = "rds-subnet-group"  # Default value
}

variable "db_credentials_secret_name" {
  description = "The name of the secret in AWS Secrets Manager that stores the DB credentials"
  type        = string
  default     = "db-credentials"  # Default value
}

variable "db_engine" {
  description = "The database engine to use (e.g., mariadb)"
  type        = string
  default     = "mariadb"  # Default value
}

variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "myrds"  # Default value
}

variable "db_instance_name" {
  description = "The name of the RDS instance"
  type        = string
  default     = "mariadb-instance"  # Default value
}

variable "allocated_storage" {
  description = "The storage size for the RDS instance"
  type        = number
  default     = 10  # Default value
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "10.6.14"  # Default value
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"  # Default value
}

variable "skip_final_snapshot" {
  description = "Whether to skip taking a final snapshot before deleting the DB instance"
  type        = bool
  default     = true  # Default value
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible"
  type        = bool
  default     = true  # Default value
}

