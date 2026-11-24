variable "aws_region" {
  description = "AWS region for Terraform bootstrap resources."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for AWS resource naming."
  type        = string
  default     = "infra-as-code-pipeline"
}