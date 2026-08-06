variable "name_prefix" {
  type        = string
  description = "Project name prefix for resource naming"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc)."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS will be created."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnet Ids used by EKS cluster and node groups."
}

variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes version."
  default     = "1.31"
}

variable "endpoint_private_access" {
  type        = bool
  description = "Enable private API server endpoint access."
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Enable public API server endpoint access."
  default     = false
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to access public API endpoint."
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  description = "Control plane logs to enable."
  default     = ["api", "audit", "authenticator"]
}

variable "cluster_addons" {
  type        = list(string)
  description = "EKS addons to install."
  default     = ["coredns", "kube-proxy", "vpc-cni"]
}

variable "node_groups" {
  description = "Managed node groups configuration."
  type = map(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
    capacity_types = optional(string, "ON_DEMAND")
    disk_size      = optional(number, 20)
    ami_type       = optional(string, "AL2_x86_64")
    labels         = optional(optional(map(string), {}))
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
}

variable "node_remote_access" {
  description = "Optional remote access settings for managed node groups."
  type = object({
    ec2_ssh_key               = string
    source_security_group_ids = list(string)
  })
  default = null
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply resources."
  default     = {}
}
