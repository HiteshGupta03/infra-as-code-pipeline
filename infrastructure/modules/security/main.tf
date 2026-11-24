
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Allow public HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  })
}

# Frontend
resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-${var.environment}-frontend-sg"
  description = "Allow traffic from ALB to frontend"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-frontend-sg"
  })
}

# Backend
resource "aws_security_group" "backend" {
  name        = "${var.project_name}-${var.environment}-backend-sg"
  description = "Allow traffic from frontend to backend"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-backend-sg"
  })
}

# Database
resource "aws_security_group" "database" {
  name        = "${var.project_name}-${var.environment}-database-sg"
  description = "Allow MySQL traffic from backend only"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-database-sg"
  })
}

# ALB: Public HTTP access
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Public HTTP access"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Frontend: Only ALB can access port 80
resource "aws_vpc_security_group_ingress_rule" "frontend_from_alb" {
  security_group_id            = aws_security_group.frontend.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

# Backend: Only ALB can access API port 5000
resource "aws_vpc_security_group_ingress_rule" "backend_from_alb" {
  security_group_id            = aws_security_group.backend.id
  referenced_security_group_id = aws_security_group.alb.id
  description                  = "Allow API traffic from ALB"

  from_port   = 5000
  to_port     = 5000
  ip_protocol = "tcp"
}

# Database: Only backend ECS tasks can access MySQL
resource "aws_vpc_security_group_ingress_rule" "database_from_backend" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.backend.id
  description                  = "Allow MySQL traffic from backend ECS tasks"

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
}

# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  for_each = {
    alb      = aws_security_group.alb.id
    frontend = aws_security_group.frontend.id
    backend  = aws_security_group.backend.id
    database = aws_security_group.database.id
  }

  security_group_id = each.value
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ECS Task Execution Role
resource "aws_iam_role" "task_execution" {
  name = substr(
    "${var.project_name}-${var.environment}-ecs-execution",
    0,
    64
  )

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

# Attach AWS Managed ECS Execution Policy
resource "aws_iam_role_policy_attachment" "task_execution" {
  role = aws_iam_role.task_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Application Task Role
resource "aws_iam_role" "task" {
  name = substr(
    "${var.project_name}-${var.environment}-ecs-task",
    0,
    64
  )

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

# GitHub Actions Deployment Role
resource "aws_iam_role" "github_actions" {
  name = substr(
    "${var.project_name}-${var.environment}-github-actions",
    0,
    64
  )

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = var.github_oidc_provider_arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

          "token.actions.githubusercontent.com:sub" = "repo:HiteshGupta03@181136551/infra-as-code-pipeline@1445863299:environment:${var.environment}"
        }
      }
    }]
  })

  tags = local.common_tags
}

# Data sources for AWS account and region
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}


# GitHub Actions Application Deployment Permissions
resource "aws_iam_role_policy" "github_actions_deploy" {
  name = "${var.project_name}-${var.environment}-github-deploy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "PushImagesToProjectECRRepositories"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = [
          "arn:${data.aws_partition.current.partition}:ecr:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}-${var.environment}-frontend",
          "arn:${data.aws_partition.current.partition}:ecr:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}-${var.environment}-backend"
        ]
      },
      {
        Sid      = "AuthenticateToECR"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"

        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = data.aws_region.current.region
          }
        }
      },
      {
        Sid    = "RegisterProjectTaskDefinitions"
        Effect = "Allow"

        Action = [
          "ecs:RegisterTaskDefinition",
          "ecs:TagResource"
        ]

        Resource = [
          "arn:${data.aws_partition.current.partition}:ecs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:task-definition/${var.project_name}-${var.environment}-frontend:*",
          "arn:${data.aws_partition.current.partition}:ecs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:task-definition/${var.project_name}-${var.environment}-backend:*"
        ]
      },
      {
        Sid      = "DescribeProjectTaskDefinitions"
        Effect   = "Allow"
        Action   = ["ecs:DescribeTaskDefinition"]
        Resource = "*"

        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = data.aws_region.current.region
          }
        }
      },
      {
        Sid    = "DeployProjectECSServices"
        Effect = "Allow"

        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService"
        ]

        Resource = [
          "arn:${data.aws_partition.current.partition}:ecs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:service/${var.project_name}-${var.environment}-cluster/${var.project_name}-${var.environment}-frontend",
          "arn:${data.aws_partition.current.partition}:ecs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:service/${var.project_name}-${var.environment}-cluster/${var.project_name}-${var.environment}-backend"
        ]
      },
      {
        Sid    = "PassECSRoles"
        Effect = "Allow"

        Action = [
          "iam:PassRole"
        ]

        Resource = [
          aws_iam_role.task_execution.arn,
          aws_iam_role.task.arn
        ]

        Condition = {
          StringEquals = {
            "iam:PassedToService" = "ecs-tasks.amazonaws.com"
          }
        }
      }
    ]
  })
}
