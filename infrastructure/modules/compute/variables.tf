variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where compute resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the load balancer"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the ALB"
  type        = string
}

variable "aws_region" {
  description = "AWS region used by ECS and CloudWatch"
  type        = string
}

variable "frontend_security_group_id" {
  description = "Security group ID for frontend ECS tasks"
  type        = string
}

variable "backend_security_group_id" {
  description = "Security group ID for backend ECS tasks"
  type        = string
}

variable "task_execution_role_arn" {
  description = "IAM execution role used by ECS"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role assigned to application containers"
  type        = string
}

variable "frontend_log_group_name" {
  description = "CloudWatch frontend log group"
  type        = string
}

variable "backend_log_group_name" {
  description = "CloudWatch backend log group"
  type        = string
}

variable "frontend_image" {
  description = "Frontend Docker image URI in ECR"
  type        = string
}

variable "backend_image" {
  description = "Backend Docker image URI in ECR"
  type        = string
}

variable "database_host" {
  description = "RDS MySQL hostname"
  type        = string
}

variable "database_name" {
  description = "Application database name"
  type        = string
}

variable "database_username" {
  description = "RDS database username"
  type        = string
}

variable "database_secret_arn" {
  description = "Secrets Manager ARN for the RDS master password"
  type        = string
}

variable "jwt_secret_parameter_arn" {
  description = "SSM Parameter Store ARN containing the JWT secret"
  type        = string
}

variable "minimum_tasks" {
  description = "Minimum number of ECS tasks per service"
  type        = number
  default     = 2
}

variable "maximum_tasks" {
  description = "Maximum number of ECS tasks per service"
  type        = number
  default     = 6
}