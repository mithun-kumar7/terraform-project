output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP of the jump server."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IP of the jump server."
  value       = aws_instance.this.public_ip
}

output "security_group_id" {
  description = "Security group ID of the jump server."
  value       = aws_security_group.this.id
}
