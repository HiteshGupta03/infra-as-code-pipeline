output "frontend_log_group_name" {
  description = "CloudWatch log group name for frontend"
  value       = aws_cloudwatch_log_group.frontend.name
}

output "backend_log_group_name" {
  description = "CloudWatch log group name for backend"
  value       = aws_cloudwatch_log_group.backend.name
}

output "frontend_log_group_arn" {
  description = "CloudWatch log group ARN for frontend"
  value       = aws_cloudwatch_log_group.frontend.arn
}

output "backend_log_group_arn" {
  description = "CloudWatch log group ARN for backend"
  value       = aws_cloudwatch_log_group.backend.arn
}