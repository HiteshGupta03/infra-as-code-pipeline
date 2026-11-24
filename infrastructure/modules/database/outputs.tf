output "database_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.main.endpoint
}

output "database_address" {
  description = "RDS database hostname"
  value       = aws_db_instance.main.address
}

output "database_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.main.port
}

output "database_name" {
  description = "MySQL database name"
  value       = aws_db_instance.main.db_name
}

output "database_username" {
  description = "RDS master username"
  value       = aws_db_instance.main.username
}

output "database_secret_arn" {
  description = "ARN of the RDS-managed master password secret"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}