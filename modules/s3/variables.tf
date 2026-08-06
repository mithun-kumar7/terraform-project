variable "bucket_name" {
  type        = string
  description = "Unique S3 bucket name."
}

variable "force_destroy" {
  type        = bool
  description = "Allow bucket deletion even if it contains objects."
  default     = false
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable bucket versioning."
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Server-side encryption algorithm."
  default     = "AES256"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply on resources."
  default     = {}
}
