locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  database_identifier = "${var.project_name}-${var.environment}-mysql"
}

# RDS Database Subnet Group
resource "aws_db_subnet_group" "main" {
  name = "${local.database_identifier}-subnets"

  subnet_ids = var.private_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${local.database_identifier}-subnets"
  })
}

# Amazon RDS MySQL Instance
resource "aws_db_instance" "main" {
  identifier = local.database_identifier

  engine         = "mysql"
  instance_class = var.instance_class

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.database_name
  username = var.database_username

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.database_security_group_id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = var.backup_retention_days

  deletion_protection = var.deletion_protection

  skip_final_snapshot = !var.deletion_protection

  final_snapshot_identifier = var.deletion_protection ? "${local.database_identifier}-final" : null

  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  tags = merge(local.common_tags, {
    Name = local.database_identifier
  })
}