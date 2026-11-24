variable "project_name" {
  description = "Project name used for CloudWatch resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days CloudWatch retains application logs"
  type        = number
  default     = 14
}