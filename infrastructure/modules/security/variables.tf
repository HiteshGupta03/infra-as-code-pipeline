
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "github_repository" {
  description = "GitHub repository allowed to authenticate with AWS"
  type        = string
}

variable "github_oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider"
  type        = string
}