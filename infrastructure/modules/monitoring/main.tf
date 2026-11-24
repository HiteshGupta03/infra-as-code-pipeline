locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Frontend CloudWatch Log Group
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.project_name}-${var.environment}/frontend"
  retention_in_days = var.log_retention_days

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-frontend-logs"
  })
}

# Backend CloudWatch Log Group
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.project_name}-${var.environment}/backend"
  retention_in_days = var.log_retention_days

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-backend-logs"
  })
}