output "vpc_id" {
  description = "ID of the application VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.networking.private_subnet_ids
}

output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = module.security.alb_security_group_id
}

output "frontend_security_group_id" {
  description = "Security group ID for the frontend"
  value       = module.security.frontend_security_group_id
}

output "backend_security_group_id" {
  description = "Security group ID for the backend"
  value       = module.security.backend_security_group_id
}

output "database_security_group_id" {
  description = "Security group ID for the database"
  value       = module.security.database_security_group_id
}

output "frontend_ecr_repository_url" {
  description = "ECR repository URL for frontend images"
  value       = module.registry.frontend_repository_url
}

output "backend_ecr_repository_url" {
  description = "ECR repository URL for backend images"
  value       = module.registry.backend_repository_url
}

output "frontend_ecr_repository_arn" {
  description = "ECR repository ARN for frontend"
  value       = module.registry.frontend_repository_arn
}

output "backend_ecr_repository_arn" {
  description = "ECR repository ARN for backend"
  value       = module.registry.backend_repository_arn
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = module.compute.ecs_cluster_id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.compute.ecs_cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = module.compute.ecs_cluster_arn
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = module.compute.alb_arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = module.compute.alb_dns_name
}

output "frontend_target_group_arn" {
  description = "Frontend target group ARN"
  value       = module.compute.frontend_target_group_arn
}

output "backend_target_group_arn" {
  description = "Backend target group ARN"
  value       = module.compute.backend_target_group_arn
}

output "frontend_log_group_name" {
  description = "CloudWatch frontend log group"
  value       = module.monitoring.frontend_log_group_name
}

output "backend_log_group_name" {
  description = "CloudWatch backend log group"
  value       = module.monitoring.backend_log_group_name
}

output "database_endpoint" {
  description = "RDS MySQL connection endpoint"
  value       = module.database.database_endpoint
}

output "database_name" {
  description = "Application database name"
  value       = module.database.database_name
}

output "database_secret_arn" {
  description = "RDS-managed database password secret ARN"
  value       = module.database.database_secret_arn
}

output "frontend_service_name" {
  description = "Frontend ECS service name"
  value       = module.compute.frontend_service_name
}

output "backend_service_name" {
  description = "Backend ECS service name"
  value       = module.compute.backend_service_name
}

output "backend_task_definition_arn" {
  description = "Backend ECS task definition ARN"
  value       = module.compute.backend_task_definition_arn
}

output "application_url" {
  description = "Public application URL"
  value       = module.compute.application_url
}