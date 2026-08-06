variable "name_prefix" {
  type        = string
  description = "Project name prefix for resource naming."
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc)."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "az_count" {
  type        = number
  description = "Number of AZs and subnet pairs to create."
  default     = 2
}

variable "subnet_newbits" {
  type        = number
  description = "Additional subnet bits used to carve subnets from the VPC CIDR."
  default     = 4
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to create NAT gateway(s) for private subnet egress."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Whether to use a single NAT gateway for all private subnets."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply on resources."
  default     = {}
}
