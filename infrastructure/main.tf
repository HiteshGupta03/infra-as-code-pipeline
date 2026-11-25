locals {
  environment = terraform.workspace
}
module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = local.environment
  vpc_cidr     = var.vpc_cidr
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = local.environment

  vpc_id = module.networking.vpc_id

  # GitHub Actions OIDC configuration
  github_oidc_provider_arn = var.github_oidc_provider_arn
}

module "registry" {
  source = "./modules/registry"

  project_name = var.project_name
  environment  = local.environment
}

module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = local.environment
  aws_region   = var.aws_region

  # Networking
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids

  # Security
  alb_security_group_id      = module.security.alb_security_group_id
  frontend_security_group_id = module.security.frontend_security_group_id
  backend_security_group_id  = module.security.backend_security_group_id

  # IAM
  task_execution_role_arn = module.security.task_execution_role_arn
  task_role_arn           = module.security.task_role_arn

  # CloudWatch
  frontend_log_group_name = module.monitoring.frontend_log_group_name
  backend_log_group_name  = module.monitoring.backend_log_group_name

  # Docker images
  frontend_image = var.frontend_image
  backend_image  = var.backend_image

  # Database
  database_host       = module.database.database_address
  database_name       = module.database.database_name
  database_username   = module.database.database_username
  database_secret_arn = module.database.database_secret_arn

  # Application secret
  jwt_secret_parameter_arn = var.jwt_secret_parameter_arn

  # ECS scaling
  # ECS scaling
  minimum_tasks = var.minimum_tasks
  maximum_tasks = var.maximum_tasks

  # Ensure required resources and permissions exist first
  depends_on = [
    module.registry,
    aws_iam_role_policy.ecs_task_execution_secrets
  ]
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name       = var.project_name
  environment        = local.environment
  log_retention_days = var.log_retention_days
}

module "database" {
  source = "./modules/database"

  project_name = var.project_name
  environment  = local.environment

  database_name     = var.database_name
  database_username = var.database_username
  instance_class    = var.database_instance_class

  private_subnet_ids         = module.networking.private_subnet_ids
  database_security_group_id = module.security.database_security_group_id

  deletion_protection   = var.deletion_protection
  backup_retention_days = var.backup_retention_days
}

# ECS Task Execution Role - Secret Access
resource "aws_iam_role_policy" "ecs_task_execution_secrets" {
  name = "${var.project_name}-${local.environment}-ecs-secrets"
  role = module.security.task_execution_role_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ReadJWTSecret"
        Effect = "Allow"

        Action = [
          "ssm:GetParameters"
        ]

        Resource = var.jwt_secret_parameter_arn
      },
      {
        Sid    = "ReadDatabasePassword"
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = module.database.database_secret_arn
      }
    ]
  })
}