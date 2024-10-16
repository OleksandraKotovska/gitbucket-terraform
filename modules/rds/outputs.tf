output "rds_endpoint" {
  description = "The endpoint address of the RDS instance"
  value       = aws_db_instance.myrds.address
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}
output "rds_address" {
  value = aws_db_instance.myrds.address
  description = "The address of the RDS instance"
}
