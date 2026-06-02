variable "environment" {
  type        = string
  description = "The environment for which to deploy the infrastructure (e.g., dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be one of 'dev', 'staging', or 'prod'."
  }
}

variable "project" {
  type        = string
  description = "The name of the project for which to deploy the infrastructure"
  default     = "myproject"
}

variable "force_destroy" {
  type        = bool
  description = "Whether to force destroy the S3 bucket (delete all objects) when destroying the infrastructure"
  default     = false
}
