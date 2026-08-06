variable "name_prefix" {
  type        = string
  description = "Project name prefix for resource naming."
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc)."
}

variable "name_suffix" {
  type        = string
  description = "Resource name suffix for the EC2 instance."
  default     = "jump"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where jump server is created."
}

variable "subnet_id" {
  type        = string
  description = "Sybnet ID for the jump server instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the jump server."
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name for SSH login."
  default     = null
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH to jump server."
}

variable "associate_public_ip_addess" {
  type        = bool
  description = "Whether to assign a public IP to the jump server."
  default     = true
}

variable "ami_id" {
  type        = string
  description = "Optional explicit AMI ID. If null, AMI is resolved from SSM parameter."
  default     = null
}

variable "ami_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name used to resolve default Amazon Linux AMI."
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "enable_ami_rotation" {
  type        = bool
  description = "Whether to force jump server replacement on a fixed interval to refresh AMI."
  default     = true
}

variable "ami_rotation_days" {
  type        = number
  description = "Number of days between forced jump server replacement for AMI refresh."
  default     = 90
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB."
  default     = 20
}

variable "user_data" {
  type        = string
  description = "Optional user_data script."
  default     = "null"
}

variable "tags" {
  type        = map(string)
  description = "COmmon tags to apply on resources."
  default     = {}
}
