variable "name_prefix" {
  type        = string
  description = "Project name prefix for resource naming."
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc)."
}

variable "repositories" {
  description = "Map of ECR repositories to create. Key becomes part of the repository name."
  type = map(object({
    image_tag_mutability = optional(string, "IMMUTABLE")
    scan_on_push         = optional(bool, true)
    encryption_type      = optional(string, "AES256")
    kms_key              = optional(string, null)
    max_image_count      = optional(number, 30)
  }))
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all ECR resources."
  default     = {}
}
