variable "name_prefix" {
  type        = string
  description = "Project name prefix for resource naming."
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc)."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS will be created."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs used for the RDS subnet group."
}

variable "identifier_suffix" {
  type        = string
  description = "Suffix used in RDS identifier and releated resource names."
  default     = "postgres"
}

variable "db_name" {
  type        = string
  description = "Initial database name."
}

variable "master_credentials_secret_arn" {
  type        = string
  description = "ARN of Secret Manager secret containing RDS username/password JSON payload."
}

variable "secret_username_key" {
  type        = string
  description = "JSON key in secret string for DB username."
  default   = "username"
}

variable "secret_passowrd_key" {
  type = string
  description = "JSON key in secret string for DB password."
  default = "password"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
}

variable "engine_version" {
  type        = string
  description = "PostgreSQL engine version."
  default     = "16.3"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GB."
}

variable "max_allocated_storage" {
  type        = number
  description = "Maximun autoscaled storage in GB."
  default     = 200
}

variable "port" {
  type        = number
  description = "PostgreSQL port."
  default     = 5432
}

variable "multi_az" {
  type        = bool
  description = "Whether to enable Multi-AZ deployment."
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention period in days."
  default     = 7
}

variable "backup_window" {
  type        = string
  description = "Preffered backup window in UTC."
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  type        = string
  description = "Preffered maintenance window in UTC."
  default     = "sun:04:99-sun:05:00"
}

variable "storage_encrypted" {
  type        = bool
  description = "Whether to enable storage encryption."
  default     = true
}

variable "deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection."
  default     = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Whether to skip final snapshot on destroy."
  default     = true
}

variable "apply_immediately" {
  type        = bool
  description = "Apply changes immediately."
  default     = false
}

variable "performace_insights_enabled" {
  type        = bool
  description = "Enable performance insights."
  default     = false
}

variable "performance_insights_retention_period" {
  type        = number
  description = "Retention period for performance insights in days."
  default     = 7
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups allowed to connect to PostgreSQL."
  default     = []
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to connect to PostgreSQL."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply on resources."
  default     = {}
}
