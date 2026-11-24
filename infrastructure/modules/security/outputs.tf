
output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "frontend_security_group_id" {
  value = aws_security_group.frontend.id
}

output "backend_security_group_id" {
  value = aws_security_group.backend.id
}

output "database_security_group_id" {
  value = aws_security_group.database.id
}

output "task_execution_role_arn" {
  description = "IAM role ARN used by ECS for image pulling and logging"
  value       = aws_iam_role.task_execution.arn
}

output "task_role_arn" {
  description = "IAM role ARN assigned to the application containers"
  value       = aws_iam_role.task.arn
}

output "github_actions_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "task_execution_role_name" {
  description = "IAM execution role name used by ECS"
  value       = aws_iam_role.task_execution.name
}