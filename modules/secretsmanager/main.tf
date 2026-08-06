resource "aws_secretsmanager_secret" "this" {
  name                    = var.secret_name
  description             = var.description
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(var.tags, {
    Name = var.secret_name
  })
}

resource "randon_password" "this" {
  length           = var.password_length
  special          = true
  override_special = "_%@"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = var.username
    password = randon_password.this.result
  })
}
