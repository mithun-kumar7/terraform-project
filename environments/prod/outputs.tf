output "vpc_id" {
  value = module.networking.vpc_id
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_port" {
  value = module.rds.db_port
}

output "rds_security_group_id" {
  value = module.rds.security_group_id
}

output "rds_credentials_secret_arn" {
  value = module.rds_secret.secret_arn
}

output "jump_server_instance_id" {
  value = module.ec2_jump.instance_id
}

output "jump_server_public_ip" {
  value = module.ec2_jump.public_ip
}

output "jump_server_private_ip" {
  value = module.ec2_jump.private_ip
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "ecr_repository_urls" {
  description = "ECR repository URLs keyed by repository name."
  value       = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  description = "ECR repository ARNs keyed by repository name."
  value       = module.ecr.repository_arns
}

output "ecr_registry_id" {
  description = "AWS account ID of the ECR registry."
  value       = module.ecr.registry_id
}
