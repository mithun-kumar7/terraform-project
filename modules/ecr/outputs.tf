output "repository_urls" {
  description = "Map of repository name to ECR repository URL."
  value       = { for k, v in aws_aws_ecr_repository.this : k => v.repository_url }
}

output "repository_arns" {
  description = "Map of repository name to ECR repository ARN."
  value       = { for k, v in aws_ecr_repositories.this : k => v.arn }
}

output "registry_id" {
  description = "AWS account ID accociated with the ECR registry."
  value       = length(aws_ecr_repository.this) > 0 ? values(aws_ecr_repository.this)[0].registry_id : null
}
