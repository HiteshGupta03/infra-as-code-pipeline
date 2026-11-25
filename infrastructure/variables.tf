
variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for AWS resources"
  type        = string
  default     = "infra-as-code-pipeline"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "github_oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN from bootstrap"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention period"
  type        = number
  default     = 14
}

variable "database_name" {
  description = "Application database name"
  type        = string
  default     = "mbeautycakes"
}

variable "database_username" {
  description = "RDS master username"
  type        = string
  default     = "mbeauty_admin"
}

variable "database_instance_class" {
  description = "RDS database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "RDS automated backup retention"
  type        = number
  default     = 7
}

variable "frontend_image" {
  description = "Frontend Docker image URI in ECR"
  type        = string
}

variable "backend_image" {
  description = "Backend Docker image URI in ECR"
  type        = string
}

variable "jwt_secret_parameter_arn" {
  description = "ARN of the JWT secret stored in AWS SSM Parameter Store"
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