variable "secret_name" {
  type        = string
  description = "Secret Manager secret name."
}

variable "description" {
  type        = string
  description = "Secret description."
  default     = "Managed by Terraform"
}

variable "username" {
  type        = string
  description = "Username stored in secret payload."
  default     = "dbadmin"
}

variable "password_length" {
  type        = number
  description = "Generated password length."
  default     = 24
}

variable "recovery_window_in_days" {
  type        = number
  description = "Recovery window in days when deleting secret."
  default     = 7
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply on resources."
  default     = {}
}
