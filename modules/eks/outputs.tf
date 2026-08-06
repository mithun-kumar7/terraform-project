output "cluster_name" {
  description = "EKS cluster name."
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS API server endpoint."
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca" {
  description = "BASE64 encoded cluster CA data."
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer" {
  description = "OIDC issuer URL for the cluster"
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_security_group_id" {
  description = "Cluster security group ID."
  value = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "Node security group ID."
  value = aws_security_group.node.id
}

output "node_role_arn" {
  description = "Node IAM role ARN."
  value = aws_iam_role.node.arn
}

output "node_group_names" {
  description = "Managed node group names."
  value = [for ng in aws_aws_eks_node_group.this : ng.node_group_name]
}
