variable "project_name" {
  description = "Project name used for database resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "database_name" {
  description = "Initial MySQL database name"
  type        = string
  default     = "mbeautycakes"
}

variable "database_username" {
  description = "RDS master username"
  type        = string
  default     = "mbeauty_admin"
}

variable "instance_class" {
  description = "RDS database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the RDS database"
  type        = list(string)
}

variable "database_security_group_id" {
  description = "Security group ID attached to RDS"
  type        = string
}

variable "deletion_protection" {
  description = "Protect the database from accidental deletion"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}