variable "project_name" {
  type        = string
  description = "Project name prefix for resources."
}

variable "environment" {
  type        = string
  description = "Environment Name."
}

variable "aws_region" {
  type        = string
  description = "AWS region where resources are provisioned."
}

variable "aws_profile" {
  type        = string
  description = "Named AWS CLI profile for this environment/account."
}

variable "allowed_account_ids" {
  type        = list(string)
  description = "Allowed AWS account IDs for safety checks in this environment."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "az_count" {
  type        = number
  description = "Number of AZs/subnet pairs."
}

variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes version."
}

variable "endpoint_private_access" {
  type        = bool
  description = "Enable private endpoint access for EKS API."
}

variable "endpoint_public_access" {
  type        = bool
  description = "Enable public endpoint access for EKS API."
}

variable "node_groups" {
  description = "Managed node groups configuration."
  type = map(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
    capacity_type  = optional(string, "ON_DEMAND")
    disk_size      = optional(number, 20)
    ami_type       = optional(string, "AL2_x86_64")
    lables         = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
}

variable "rds" {
  description = "PostgreSQL RDS configuration."
  type = object({
    identifier_suffix                     = optional(string, "postgres")
    db_name                               = string
    instance_class                        = string
    engine_version                        = optional(string, "16.3")
    allocated_storage                     = number
    max_allocated_storage                 = optional(number, 200)
    port                                  = optional(number, 5432)
    multi_az                              = optional(bool, false)
    backup_retention_period               = optional(number, 7)
    backup_window                         = optional(string, "03:00-04:00")
    maintenance_window                    = optional(string, "sun:04:00-sun:05:00")
    storage_encrypted                     = optional(bool, true)
    deletion_protection                   = optional(bool, true)
    skip_final_snapshot                   = optional(bool, true)
    apply_immediately                     = optional(bool, false)
    performance_insights_enabled           = optional(bool, false)
    performance_insights_retention_period = optional(number, 7)
    allowed_security_group_ids            = optional(list(string), [])
    ingress_cidr_blocks                   = optional(list(status), [])
  })
}

variable "rds_secret" {
  description = "Secrets manager settings used to create and store RDS credentials."
  type = object({
    secret_name             = string
    username                = optional(string, "dbadmin")
    password_length         = optional(number, 24)
    recovery_window_in_days = optional(number, 7)
  })
}

variable "s3" {
  description = "S3 bucket configuration."
  type = object({
    bucket_name        = string
    force_destroy      = optional(bool, false)
    versioning_enabled = optional(bool, true)
    sse_algorithm      = optional(string, "AES256")
  })
}

variable "jump_server" {
  description = "Jump server configuration used for private access to RDS and nodes."
  type = object({
    instance_type               = optional(string, "t3.micro")
    key_name                    = optional(string)
    allowed_cidr_blocks         = list(string)
    associate_public_ip_address = optional(bool, true)
    ami_id                      = optional(string)
    enable_ami_rotation         = optional(bool, true)
    ami_rotation_days           = optional(number, 90)
    root_volume_size            = optional(number, 20)
  })
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags."
  default     = {}
}
